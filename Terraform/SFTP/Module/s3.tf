resource "aws_s3_bucket" "sftp_s3" {
    bucket = var.s3_bucket_name

        tags = {
            Name        = var.s3_bucket_name
        }          
} 