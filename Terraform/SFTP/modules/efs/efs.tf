resource "aws_efs_file_system" "sftp_efs" {
    
    throughput_mode = "elastic"
    lifecycle_policy {
      transition_to_ia = "AFTER_30_DAYS"
    }

    lifecycle_policy {
      transition_to_archive = "AFTER_90_DAYS"
    }
    
    tags = {
      Name           = var.tags_efs_name
      CmBillingGroup = var.tags_CmBillingGroup
    }
}

resource "aws_efs_mount_target" "mount_targets" {
  for_each = toset(var.efs_subnet_ids)
  file_system_id = aws_efs_file_system.sftp_efs.id
  subnet_id = each.value
  security_groups = [var.sg_id_of_mount_targets]

  lifecycle {
    ignore_changes = [ file_system_id ]
  }
}