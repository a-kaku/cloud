#!/usr/bin/env python3
import os
import time
import hashlib
import logging
import boto3
from botocore.exceptions import ClientError
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

# ==========================
# 設定項目
# ==========================
EFS_PATH = "/srv/efs/sftp"       # 監視対象の EFS ディレクトリ
S3_BUCKET = "h21.sftp.backup"   # アップロード先 S3 バケット名
DDB_TABLE = "efs_s3_lock"        # ファイルロック用 DynamoDB テーブル名
LOCK_TTL_SECONDS = 300           # ロック有効期限（秒）
AWS_REGION = "ap-northeast-1"    # AWS リージョン

# ==========================
# AWS クライアント初期化
# ==========================
dynamodb = boto3.resource("dynamodb", region_name=AWS_REGION)
lock_table = dynamodb.Table(DDB_TABLE)
s3 = boto3.client("s3", region_name=AWS_REGION)

# ==========================
# ログ設定
# ==========================
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s"
)

# ==========================
# DynamoDB によるファイル単位ロック
# ==========================
def acquire_lock(file_path):
    """
    指定ファイルに対してロックを取得する。
    同一ファイルに対して複数ノードが同時処理しないように制御。
    """
    lock_id = hashlib.sha256(file_path.encode()).hexdigest()
    now = int(time.time())

    try:
        lock_table.put_item(
            Item={
                "LockID": lock_id,
                "FilePath": file_path,
                "Timestamp": now
            },
            ConditionExpression="attribute_not_exists(LockID) OR Timestamp < :expire",
            ExpressionAttributeValues={
                ":expire": now - LOCK_TTL_SECONDS
            }
        )
        logging.info(f"ロック取得成功: {file_path}")
        return True

    except ClientError as e:
        if e.response["Error"]["Code"] == "ConditionalCheckFailedException":
            logging.info(f"既にロック存在のためスキップ: {file_path}")
            return False
        else:
            raise

# ==========================
# S3 アップロード処理
# ==========================
def upload_to_s3(file_path):
    """
    ファイルを S3 にアップロードする。
    ディレクトリ構造を維持したまま保存。
    """
    s3_key = os.path.relpath(file_path, EFS_PATH)

    try:
        s3.upload_file(file_path, S3_BUCKET, s3_key)
        logging.info(f"アップロード完了: s3://{S3_BUCKET}/{s3_key}")
        return True

    except Exception as e:
        logging.error(f"アップロード失敗: {file_path} - {e}")
        return False

# ==========================
# ファイルイベントハンドラ
# ==========================
class EFSHandler(FileSystemEventHandler):
    """
    ファイルの close_write イベント発生時に処理を実行
    """

    def on_closed(self, event):
        if event.is_directory:
            return

        file_path = event.src_path

        if os.path.isfile(file_path):
            # ロック取得できた場合のみアップロード実行
            if acquire_lock(file_path):
                upload_to_s3(file_path)

# ==========================
# メイン処理
# ==========================
def main():
    """
    EFS ディレクトリを再帰的に監視し、
    ファイル書き込み完了イベントを検知する。
    """
    observer = Observer()
    event_handler = EFSHandler()

    observer.schedule(event_handler, path=EFS_PATH, recursive=True)
    observer.start()

    logging.info(f"{EFS_PATH} の監視を開始しました")

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()

    observer.join()

if __name__ == "__main__":
    main()
