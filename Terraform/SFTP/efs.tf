resource "aws_efs_file_system" "sftp_efs" {
    
    throughput_mode = "elastic"
    lifecycle_policy {
      transition_to_ia = "AFTER_30_DAYS"
    }

    lifecycle_policy {
      transition_to_archive = "AFTER_90_DAYS"
    }
    
    tags = {
      Name           = "SFTP-Shared"
      CmBillingGroup = "h21local"
    }
}

resource "aws_efs_mount_target" "mount_targets" {
  for_each = toset(var.efs_subnet_ids)
  file_system_id = aws_efs_file_system.sftp_efs.id
  subnet_id = each.value
  security_groups = ["sg-0f724466d87b9ab49"]
}