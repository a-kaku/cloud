provider "aws" {
  region = "ap-northeast-1"
}

module "sftp_instance" {
  source = "../module/ec2"
  efs_subnet_ids = var.efs_subnet_ids
}