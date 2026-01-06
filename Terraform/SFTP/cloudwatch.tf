resource "aws_cloudwatch_log_group" "sftp_01" {
    name = "/aws/instance/sftp/log/${module.sftp-01.instance_ids.sftp_01}-sftp.log"
    retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "sftp_process_01" {
    name = "/aws/instance/sftp/log/${module.sftp-01.instance_ids.sftp_01}-sftp_process.log"
    retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "secure_01" {
    name = "/aws/instance/sftp/log/${module.sftp-01.instance_ids.sftp_01}-secure.log"
    retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "sftp_02" {
    name = "/aws/instance/sftp/log/${module.sftp-02.instance_ids.sftp_02}-sftp.log"
    retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "sftp_process_02" {
    name = "/aws/instance/sftp/log/${module.sftp-02.instance_ids.sftp_02}-sftp_process.log"
    retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "secure_02" {
    name = "/aws/instance/sftp/log/${module.sftp-02.instance_ids.sftp_02}-secure.log"
    retention_in_days = 30
}