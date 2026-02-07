#!/bin/bash
LOG_DIR="/etc/logrotate.d/rsyslog"
S3_BUCKET="s3:// "
DATE=$(date +%Y-%m-%d)

aws s3 sync $LOG_DIR $S3_BUCKET/ --delete

echo "$(date +"%Y-%m-%d %H:%M:%S") - S3にバックアップしました。" >> /var/log/s3-backup.log
