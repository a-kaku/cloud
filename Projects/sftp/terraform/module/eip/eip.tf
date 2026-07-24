resource "aws_eip" "subnet_eip" {
    for_each = toset(var.nlb_subnet_ids)
    tags = {
      Name           = var.Name
      CmBillingGroup = var.CmBillingGroup
    }
}