variable "tags_efs_name" {
  description = "The name of the EFS file system."
  type = string
  default     = "SFTP-Shared"
}

variable "tags_CmBillingGroup" {
  description = "The billing group to use for EFS file system."
  type = string
  default     = "h21local"
}

variable "sg_id_of_mount_targets" {
  description = "The security group ID to use for EFS mount targets."
  type = string
  default = "sg-0f724466d87b9ab49"
}