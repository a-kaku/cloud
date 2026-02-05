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

variable "CmBillingGroup" {
  description = "The billing group to use for S3 bucket resource."
  type = string
  default = "h21local"
}