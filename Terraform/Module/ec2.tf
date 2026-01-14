resource "aws_instance" "sftp" {
  for_each = var.instances
  ami           = var.instance_ami
  instance_type = "t3.small"
  subnet_id     = local.subnets[each.key]
  key_name = "h21local"
  iam_instance_profile = data.aws_iam_instance_profile.ec2_for_efs_s3_cloudwatch.name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"

    tags = {
      Name = "${each.key}"
      CmBillingGroup = "h21local"
      Role = "sftp-server"
    }
  }

  vpc_security_group_ids = [
    data.aws_security_group.sftp_test.id
  ]

  tags = {
    Name            = each.key
    Owner           = "h21local"
    CmBillingGroup  = "h21local"
    Role           = "sftp-server"
  }
}

data "aws_vpc" "vpc_h21group" {
  id = "vpc-66901d03"
}

data "aws_subnet" "h21local_d" {
  id = "subnet-0ace5ac2c0711268e"
}

data "aws_subnet" "h21local_a" {
  id = "subnet-04ac6c682bf80de34"
}

data "aws_security_group" "sftp_test" {
  id = "sg-0ff56c6020c4aff70"
}

data "aws_iam_instance_profile" "ec2_for_efs_s3_cloudwatch" {
  name = "ec2_for_efs_s3_cloudwatch"
}