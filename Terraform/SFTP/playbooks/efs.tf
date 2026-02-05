module "sftp_efs" {
  source = "../module/efs"
  efs_subnet_ids = var.efs_subnet_ids
}