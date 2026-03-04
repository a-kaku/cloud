#!/usr/bin/bash
INSTANCE_ID="sftp-01"
DATE=$(date +%F -d "yesterday")
PREFIX="sftp/${DATE}/${INSTANCE_ID}"

aws logs create-export-task \
  --task-name "sftp-export-${DATE}" \
  --log-group-name "/aws/instance/sftp/log" \
  --from $(date -d "${DATE} 00:00:00" +%s000) \
  --to $(date -d "${DATE} 23:59:59" +%s000) \
  --destination "h21.systemlog" \
  --destination-prefix "${PREFIX}"
