resource "aws_cloudwatch_log_group" "sftp" {
    for_each = module.sftp.instance_ids
    name = "/aws/instance/sftp/log/${each.value}-sftp.log"
    retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "sftp_process" {
    for_each = module.sftp.instance_ids
    name = "/aws/instance/sftp/log/${each.value}-sftp_process.log"
    retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "secure" {
    for_each = module.sftp.instance_ids
    name = "/aws/instance/sftp/log/${each.value}-secure.log"
    retention_in_days = 30
}