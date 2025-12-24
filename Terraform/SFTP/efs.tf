resource "aws_efs_file_system" "sftp_efs" {
    tags = {
      Name           = "SFTP-Shared"
      CmBillingGroup = "h21local"
    }
}