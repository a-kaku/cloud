resource "aws_cloudwatch_log_group" "sftp" {
    name = "/aws/instance/sftp/log/sftp.log"
    retention_in_days = 30
}

resource "aws_cloud_watch_log_group" "sftp_process" {
    name = "/aws/instance/sftp/log/sftp_process.log"
    retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "secure" {
    name = "/aws/instance/sftp/log/secure.log"
    retention_in_days = 30
}