resource "aws_s3_bucket" "sftp_s3" {
    bucket = var.s3_bucket_name

        tags = {
            Name        = var.s3_bucket_name
            CmBillingGroup = var.CmBillingGroup
        }          
} 

resource "aws_s3_bucket_lifecycle_configuration" "sftp_s3_lifecycle" {
    bucket = aws_s3_bucket.sftp_s3.id

    rule {
        id     = "Expire old objects"
        status = "Enabled"

        expiration {
            days = var.s3_bucket_expiration_days
        }

        filter {
            prefix = ""
        }
    }
}