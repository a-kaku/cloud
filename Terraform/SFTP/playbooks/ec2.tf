module "sftp" {
  source = "../module"
  efs_subnet_ids = var.efs_subnet_ids
}

# data "aws_vpc" "vpc_h21group" {
#   id = "vpc-66901d03"
# }

# data "aws_subnet" "h21local_d" {
#   id = "subnet-0ace5ac2c0711268e"
# }

# data "aws_subnet" "h21local_a" {
#   id = "subnet-04ac6c682bf80de34"
# }

# data "aws_security_group" "sftp_test" {
#   id = "sg-0ff56c6020c4aff70"
# }

# data "aws_iam_instance_profile" "ec2_for_efs_s3_cloudwatch" {
#   name = "ec2_for_efs_s3_cloudwatch"
# }