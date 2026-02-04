resource "aws_ssm_parameter" "sssd_conf" {
    name = "/h21/sftp/sssd_conf"
    type = "String"
    value = var.sssd_conf
}

resource "aws_ssm_parameter" "sshd_conf" {
    name = "/h21/sftp/sshd_conf"
    type = "String"
    value = var.sshd_conf
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
      "name": "DupdateSSSD",
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
  document_format = "JSON"

  content = <<DOC
{
  "schemaVersion": "2.2",
  "description": "Deploy sshd_config to EC2 (safe, no truncate)",
  "mainSteps": [
    {
      "action": "aws:runShellScript",
      "name": "UpdateSSHDConfig",
      "onFailure": "Abort",
      "inputs": {
        "runCommand": [
          "set -euo pipefail",
          "",
          "PARAM_NAME=\\"/h21/sftp/sshd_conf\\"",
          "TMP_FILE=$(mktemp /tmp/sshd_config.XXXXXX)",
          "",
          "# Fetch parameter value safely (no redirection)",
          "SSHD_VALUE=$(aws ssm get-parameter \\\\",
          "  --name \\"$PARAM_NAME\\" \\\\",
          "  --with-decryption \\\\",
          "  --query 'Parameter.Value' \\\\",
          "  --output text)",
          "",
          "# Validate parameter content",
          "if [ -z \\"$SSHD_VALUE\\" ] || [ \\"$SSHD_VALUE\\" = \\"None\\" ]; then",
          "  echo \\"ERROR: SSM parameter $PARAM_NAME is empty or missing\\" >&2",
          "  exit 1",
          "fi",
          "",
          "# Write to temp file",
          "echo \\"$SSHD_VALUE\\" > \\"$TMP_FILE\\"",
          "",
          "# Secure permissions",
          "chmod 600 \\"$TMP_FILE\\"",
          "chown root:root \\"$TMP_FILE\\"",
          "",
          "# Validate sshd config syntax before replacing",
          "sshd -t -f \\"$TMP_FILE\\"",
          "",
          "# Atomic replace",
          "mv \\"$TMP_FILE\\" /etc/ssh/sshd_config"
        ]
      }
    },
    {
      "action": "aws:runShellScript",
      "name": "RestartSSHD",
      "onFailure": "Abort",
      "inputs": {
        "runCommand": [
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