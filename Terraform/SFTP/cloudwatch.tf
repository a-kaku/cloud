resource "aws_cloudwatch_log_group" "sftp" {
    for_each = var.instances
    name = "/aws/instance/sftp/log/${module.sftp.instance_ids[each.key]}-sftp.log"
    retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "sftp_process" {
    for_each = var.instances
    name = "/aws/instance/sftp/log/${module.sftp.instance_ids[each.key]}-sftp_process.log"
    retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "secure" {
    for_each = var.instances
    name = "/aws/instance/sftp/log/${module.sftp.instance_ids[each.key]}-secure.log"
    retention_in_days = 30
}