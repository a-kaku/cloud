#!/bin/bash

# ==== 設定部分 ====
WATCH_DIR="/mnt/share"               # 監視するディレクトリ
S3_BUCKET="s3:// " # アップロード先 S3
AWS_PROFILE="default"                        # AWS CLI プロファイル
LOG_FILE="/var/log/s3_auto_upload.log"       # ログファイルの保存先

# ==== 前準備 ====
# ログファイル作成（存在しなければ）
touch "$LOG_FILE"
chmod 644 "$LOG_FILE"

# ==== 監視開始 ====
inotifywait -m -r -e create --format '%w%f' "$WATCH_DIR" | while read NEWFILE
do
    # ファイルが存在する場合のみ
    if [ -f "$NEWFILE" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') 新しいファイル検出: $NEWFILE" | tee -a "$LOG_FILE"

        # AWS CLI の断点再開を有効にしてアップロード
        aws s3 cp "$NEWFILE" "$S3_BUCKET" \
            --profile "$AWS_PROFILE" \
            --expected-size "$(stat -c%s "$NEWFILE")" \
            --only-show-errors

        if [ $? -eq 0 ]; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') アップロード成功: $NEWFILE" | tee -a "$LOG_FILE"
        else
            echo "$(date '+%Y-%m-%d %H:%M:%S') アップロード失敗: $NEWFILE。再試行予定。" | tee -a "$LOG_FILE"

            # 再試行（3回まで）
            for retry in 1 2 3
            do
                echo "$(date '+%Y-%m-%d %H:%M:%S') 再試行 $retry 回目: $NEWFILE" | tee -a "$LOG_FILE"
                aws s3 cp "$NEWFILE" "$S3_BUCKET" \
                    --profile "$AWS_PROFILE" \
                    --expected-size "$(stat -c%s "$NEWFILE")" \
                    --only-show-errors
                if [ $? -eq 0 ]; then
                    echo "$(date '+%Y-%m-%d %H:%M:%S') 再試行成功: $NEWFILE" | tee -a "$LOG_FILE"
                    break
                fi
            done
        fi
    fi
done

