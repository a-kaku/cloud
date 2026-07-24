variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table."
  type        = string
  default     = "efs-s3-lock-table"
}

variable "dynamodb_hash_key" {
  description = "The hash key for the DynamoDB table."
  type        = string
  default     = "LockID"
}

variable "CmBillingGroup" {
    description = "The billing group to use for resources."
    type        = string
    default     = "h21local"
}