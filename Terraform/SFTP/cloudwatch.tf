resource "aws_cloudwatch_log_group" "sftp_01" {
    name = "/aws/instance/sftp/log/${aws_instance.sftp_tmp01.id}-sftp.log"
    retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "sftp_process_01" {
    name = "/aws/instance/sftp/log/${aws_instance.sftp_tmp01.id}-sftp_process.log"
    retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "secure_01" {
    name = "/aws/instance/sftp/log/${aws_instance.sftp_tmp01.id}-secure.log"
    retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "sftp_02" {
    name = "/aws/instance/sftp/log/${aws_instance.sftp_tmp02.id}-sftp.log"
    retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "sftp_process_02" {
    name = "/aws/instance/sftp/log/${aws_instance.sftp_tmp02.id}-sftp_process.log"
    retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "secure_02" {
    name = "/aws/instance/sftp/log/${aws_instance.sftp_tmp02.id}-secure.log"
    retention_in_days = 30
}