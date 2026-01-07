variable "instances" {
  description = "Variables for EC2 instances."
  type = map(any)
  default = {
    sftp-01 = {}
    sftp-02 = {}
  }
}

variable "subnet_id" {
  description = "The subnet Id to launch the EC2 instances in."
  type = map(string)
  default = {
    sftp-01 = data.aws_subnet.h21local_d.id
    sftp-02 = data.aws_subnet.h21local_a.id
  }
}


resource "aws_instance" "sftp" {
  for_each = var.instances
  ami           = var.instance_ami
  instance_type = "t3.small"
  subnet_id     = var.subnet_id[each.key]
  key_name = "h21local"
  iam_instance_profile = data.aws_iam_instance_profile.ec2_for_efs_s3_cloudwatch.name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
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

resource "aws_network_interface" "sftp_eni" {
  for_each = aws_instance.sftp
  subnet_id = var.subnet_id[each.key]
  tags = {
    Name = "${each.key}-eni"
    CmBillingGroup  = "h21local"
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