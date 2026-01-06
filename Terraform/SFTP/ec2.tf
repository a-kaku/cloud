module "sftp-01" {
  source = "/../Module/"

  instance_name       = "SFTP-01"
  instance_ami = var.instance_ami
  subnet_id           = data.aws_subnet.h21local_d.id
  root_block_device = {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name            = "SFTP-01"
    Owner           = var.owner
    CmBillingGroup  = var.CmBillingGroup
  }

  vpc_security_group_ids = [data.aws_security_group.sftp_test.id]

  iam_instance_profile = data.aws_iam_instance_profile.ec2_for_efs_s3_cloudwatch.name

}

module "sftp-02" {
  source = "/../Module/"

  instance_name = "SFTP-02"
  instance_ami = var.instance_ami
  subnet_id = data.aws_subnet.h21local_a.id
  root_block_device = {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name            = "SFTP-02"
    Owner           = var.owner
    CmBillingGroup  = var.CmBillingGroup
  }

  vpc_security_group_ids = [data.aws_security_group.sftp_test.id]
  iam_instance_profile = data.aws_iam_instance_profile.ec2_for_efs_s3_cloudwatch.name

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