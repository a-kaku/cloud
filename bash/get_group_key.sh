#!/bin/bash
USER="$1"
KEY_FILE="/srv/efs/sftp/.users/$USER/authorized_keys"

if [ -f "$KEY_FILE" ]; then
    cat "$KEY_FILE"
fi

