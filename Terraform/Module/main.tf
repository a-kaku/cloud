provider "aws" {
  region = "ap-northeast-1"
}

module "efs" {
  source = "./moudules/efs"
  subnet_ids = var.efs_subnet_ids
}

