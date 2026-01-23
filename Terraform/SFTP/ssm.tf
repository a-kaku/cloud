resource "aws_ssm_parameter" "sssd_conf" {
    name = "/h21/sftp/sssd_conf"
    type = "String"
    value = <<EOF
[sssd]
domains = hgs.h21group.com
config_file_version = 2
services = nss, pam

[domain/hgs.h21group.com]
default_shell = /bin/bash
krb5_store_password_if_offline = True
cache_credentials = True
krb5_realm = HGS.H21GROUP.COM
realmd_tags = manages-system joined-with-adcli
id_provider = ad
ad_domain = hgs.h21group.com
use_fully_qualified_names = false
ldap_id_mapping = True
access_provider = ad
ldap_group_nesting_level = 1
#enumerate = true
ldap_sasl_mech = GSSAPI

fallback_homedir = /srv/efs/sftp/users/%u
default_shell = /sbin/nologin
EOF
}

resource "aws_ssm_parameter" "sshd_conf" {
    name = "/h21/sftp/sshd_conf"
    type = "String"
    value = <<EOF
# ==== グローバル設定 ====
Port 22
# 複数ある場合は下記のように併記 ただし、通常のSSHDと競合しないように注意
# port 8022
Subsystem sftp internal-sftp -f AUTH -l VERBOSE
PubkeyAuthentication yes
PasswordAuthentication yes
UsePAM yes
# SyslogFacilityの分離 /var/log/sftp.logへの出力
SyslogFacility LOCAL5

# ==== SFTP送信・受信ユーザーグループ基本設定 ====
Match Group sftp_send,sftp_recv
AuthenticationMethods password
PubkeyAuthentication no
PasswordAuthentication yes
ChrootDirectory /srv/efs/sftp/users/%u
ForceCommand internal-sftp -f AUTH -l INFO
X11Forwarding no
AllowTcpForwarding no
LogLevel VERBOSE

# ==== 特定ユーザー 公開鍵認証のみ ====
# Match User xxxxx1
# AuthenticationMethods publickey
# AuthorizedKeysFile /srv/efs/sftp/users/%u/.ssh/authorized_keys
# PubkeyAuthentication no
# PasswordAuthentication yes

# ==== 特定ユーザー 公開鍵認証+パスワード併用 ====
# Match User xxxxx2
# AuthenticationMethods publickey,password
# AuthorizedKeysFile /srv/efs/sftp/users/%u/.ssh/authorized_keys
# PubkeyAuthentication yes
# PasswordAuthentication yes
EOF
}

resource "aws_ssm_document" "sssd_doc" {
  name          = "UpdateSSSD"
  document_type = "Command"

  content = <<DOC
{
  "schemaVersion": "2.2",
  "description": "Deploy sssd.conf to EC2",
  "mainSteps": [
    {
      "action": "aws:runShellScript",
      "name": "DownloadConfigFromSSM",
      "inputs": {
        "runCommand": [
          "aws ssm get-parameter --name \"/config/sssd/sssd.conf\" --with-decryption --query \"Parameter.Value\" --output text > /etc/sssd/sssd.conf",
          "if [ ! -s \"/etc/sssd/sssd.conf\" ]; then echo \"Error: Failed to download sssd.conf from SSM Parameter Store\"; exit 1; fi"
        ]
      }
    },
    {
      "action": "aws:runShellScript",
      "name": "SetPermissionsAndRestart",
      "inputs": {
        "runCommand": [
          "chmod 600 /etc/sssd/sssd.conf",
          "chown root:root /etc/sssd/sssd.conf",
          "systemctl restart sssd",
          "systemctl --no-pager status sssd || exit 1"
        ]
      }
    }
  ]
}
DOC
}


resource "aws_ssm_document" "sshd_doc" {
  name          = "UpdateSSHD"
  document_type = "Command"

  content = <<DOC
{
  "schemaVersion": "2.2",
  "description": "Deploy sshd_config to EC2",
  "mainSteps": [
    {
      "action": "aws:runShellScript",
      "name": "DownloadSSHDConfig",
      "inputs": {
        "runCommand": [
          "aws ssm get-parameter --name \"/config/ssh/sshd_config\" --with-decryption --query \"Parameter.Value\" --output text > /etc/ssh/sshd_config",
          "if [ ! -s \"/etc/ssh/sshd_config\" ]; then echo \"Error: Failed to download sshd_config\"; exit 1; fi"
        ]
      }
    },
    {
      "action": "aws:runShellScript",
      "name": "ValidateAndRestartSSHD",
      "inputs": {
        "runCommand": [
          "chmod 600 /etc/ssh/sshd_config",
          "chown root:root /etc/ssh/sshd_config",
          "sshd -t",
          "systemctl restart sshd"
        ]
      }
    }
  ]
}
DOC
}


resource "aws_ssm_association" "sssd_assoc" {
  name            = aws_ssm_document.sssd_doc.name
  association_name = "UpdateSSSD-assoc"

  targets {
    key = "tag:Role"
    values = ["sftp-server"]
  }

  schedule_expression = "cron(0 0 0/4 1/1 * ? *)"
  compliance_severity = "HIGH"  
}

resource "aws_ssm_association" "sshd_assoc" {
  name            = aws_ssm_document.sshd_doc.name
  association_name = "UpdateSSHD-assoc"

  targets {
    key = "tag:Role"
    values = ["sftp-server"]
  }

  schedule_expression = "cron(0 0 0/4 1/1 * ? *)"
  compliance_severity = "HIGH"
}