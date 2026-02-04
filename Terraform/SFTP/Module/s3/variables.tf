variable "s3_bucket_name" {
  description = "The name of the S3 bucket to be created."
  type = string
  default = "h21.sftp.backup"
}

variable "s3_bucket_expiration_days" {
  description = " Number of days after which objects in the S3 bucket will expire."
  type = number
  default = 30
}