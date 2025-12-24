resource "aws_instance" "sftp_tmp01" {
  ami           = "ami-040573aabcd4f9b69"
  instance_type = "t3.medium"
  subnet_id     = data.aws_subnet.h21local_d.id

  vpc_security_group_ids = [
    data.aws_security_group.sftp_test.id
  ]

  iam_instance_profile = data.aws_iam_instance_profile.ec2_for_efs_s3_cloudwatch.name

  tags = {
    Name            = "SFTP-tmp01"
    Owner           = "h21local"
    CmBillingGroup  = "h21local"
    Role           = "sftp-server"
  }
}

resource "aws_instance" "sftp_tmp02" {
  ami           = "ami-040573aabcd4f9b69"
  instance_type = "t3.medium"
  subnet_id     = data.aws_subnet.h21local_a.id

  vpc_security_group_ids = [
    data.aws_security_group.sftp_test.id
  ]

  iam_instance_profile = data.aws_iam_instance_profile.ec2_for_efs_s3_cloudwatch.name

  tags = {
    Name            = "SFTP-tmp02"
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