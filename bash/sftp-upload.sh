#!/bin/bash
set -euo pipefail

#=== 変数 ===#
SRC_DIR="/mnt/share"
LOG_FILE="/var/log/sftp_upload.log"
SFTP_USER="ec2-user"
SFTP_HOST="    "  #ip address
SFTP_DIR="/remote/path"
TMP_FILE="/tmp/sftp_batch.txt"
PSK="/home/ec2-user/MyServer001.pem"  

#=== 事前設定 ===#
touch "$LOG_FILE" "$LOG_FILE.detail"

# 空ディレクトリでも安全にループできるように
shopt -s nullglob

#=== ループ ===#
for file in "$SRC_DIR"/*; do
    filename=$(basename "$file")

    # 既にアップロード済みならスキップ
    if grep -Fxq "$filename" "$LOG_FILE"; then
        continue
    fi

    # 通常ファイルのみ対象
    if [[ -f "$file" ]]; then
        # SFTP バッチファイル生成
        printf 'put "%s" "%s/%s"\n' "$file" "$SFTP_DIR" "$filename" > "$TMP_FILE"

        # アップロード実行
        if sftp -i "$PSK" -b "$TMP_FILE" "$SFTP_USER@$SFTP_HOST"; then
            {
                echo "$filename"
                printf '%s Uploaded: %s\n' "$(date '+%F %T')" "$filename"
            } >> "$LOG_FILE"
            echo "[$(date '+%F %T')] success: $filename" | logger -t sftp_upload
        else
            printf '%s Failed: %s\n' "$(date '+%F %T')" "$filename" >> "${LOG_FILE}.detail"
            echo "[$(date '+%F %T')] fail: $filename" | logger -t sftp_upload
        fi
    fi
done

# 後片付け
rm -f "$TMP_FILE"

