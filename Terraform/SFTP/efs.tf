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