variable "instances" {
  description = "Variables for EC2 instances."
  type = map(any)
  default = {
    "sftp-01" = {}
    "sftp-02" = {}
  }
}

locals {
  subnets = {
    sftp-01 = data.aws_subnet.h21local_d.id
    sftp-02 = data.aws_subnet.h21local_a.id
  }
}

variable "owner" {
  description = "The owner to use for server resource."
  type = string
  default     = "h21local"
}

variable "CmBillingGroup" {
  description = "The billing group to use for server resource."
  type = string
  default     = "h21local"
}

variable "tags" {
  description = "The tags to use for server resource."
  type = map(string)
  default = {}
}

variable "instance_ami" {
  description = "RHEL9.7 AMI ID to use for the EC2 instance."
  type = string
  default     = "ami-040573aabcd4f9b69"
}

variable "efs_subnet_ids" {
  description = "Subnets for EFS mount targets."
  type = list(string)
}

/*
variable "ingress_rule" {
    description = "Ingress rule for security group."
    type = list(object({
        from_port = number
        to_port = number
        protocol = string
        cidr_blocks = list(string)
    }))
}

variable "egress_rule" {
    description = "Egress rule for security group."
    type = list(object({
        from_port = number
        to_port = number
        protocol = string
        cidr_blocks = list(string)
    }))
}
*/

# variable "s3_bucket_name" {
#   description = "The name of the S3 bucket to be created."
#   type = string
#   default = "h21.sftp.backup"
# }

# variable "s3_bucket_expiration_days" {
#   description = " Number of days after which objects in the S3 bucket will expire."
#   type = number
#   default = 30
# }