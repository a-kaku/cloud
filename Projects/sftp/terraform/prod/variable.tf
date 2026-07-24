# variable "instances" {
#   description = "Variables for EC2 instances."
#   type        = map(any)
#   default = {
#     "sftp-01" = {}
#     "sftp-02" = {}
#   }
# }

variable "efs_subnet_ids" {
  description = "Subnets for EFS mount targets."
  type        = list(string)
}

# variable "sssd_conf" {
#   type = string
#   description = "Contents of the sssd.conf."
# }

# variable "sshd_conf" {
#   type = string
#   description = "Contents of the sshd_conf."


# variable "sssd_conf" {
#   type = string
#   description = "Contents of the sssd.conf."
# }

# variable "sshd_conf" {
#   type = string
#   description = "Contents of the sshd_conf."
# }

variable "eip_allocation_ids" {
  type = map(string)
}

variable "target_instance_ids" {
  type = map(string)
}

variable "nlb_config" {
  type = map(object({
    subnet_name   = string
    allocation_id = string
  }))
}