module "sftp_s3" {
    source = "../Module"
    efs_subnet_ids = var.efs_subnet_ids
}