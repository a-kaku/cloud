resource "aws_eip" "subnet_eip" {
    for_each = toset(var.sftp_nlb_subnet_ids)
    tags = {
      Name           = var.Name
      CmBillingGroup = var.CmBillingGroup
    }
}