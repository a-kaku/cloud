variable "sftp_nlb_subnet_ids" {
  description = "Subnet IDs for SFTP NLB."
  type        = list(string)
  default = [ "subnet-0619603784afdc2fc", "subnet-0d2a9560d1d5556e7" ]
}

variable "Name" {
  description = "Name prefix for resources."
  type        = string
  default     = "SFTP-NLB-EIP"
}

variable "CmBillingGroup" {
  type = string
  default = "h21local"
}

