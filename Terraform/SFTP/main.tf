provider "aws" {
  region = "ap-northeast-1"
}

module "efs" {
  source = "./module"
  efs_subnet_ids = var.efs_subnet_ids
}

