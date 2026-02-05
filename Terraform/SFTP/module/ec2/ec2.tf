resource "aws_instance" "sftp" {
  for_each = var.instances
  ami           = var.instance_ami
  instance_type = "t3.small"
  subnet_id     = local.subnets[each.key]
  key_name = var.key_name
  iam_instance_profile = data.aws_iam_instance_profile.iam_profile.name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"

    tags = {
      Name = "${each.key}"
      CmBillingGroup = var.CmBillingGroup
      Role = "sftp-server"
    }
  }

  vpc_security_group_ids = [
    data.aws_security_group.sg.id
  ]

  tags = {
    Name            = each.key
    Owner           = var.owner
    CmBillingGroup  = var.CmBillingGroup
    Role           = "sftp-server"
  }
}

data "aws_vpc" "vpc_object" {
  id = var.vpc_id
}

data "aws_subnet" "subnet_d" {
  id = var.subnet_d_id
}

data "aws_subnet" "subnet_a" {
  id = var.subnet_a_id
}

data "aws_security_group" "sg" {
  id = var.sg_id
}

data "aws_iam_instance_profile" "iam_profile" {
  name = var.iam_name
}