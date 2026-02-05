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
    sftp-01 = data.aws_subnet.subnet_d.id
    sftp-02 = data.aws_subnet.subnet_a.id
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

variable "key_name" {
  type = string
  default = "h21local"
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

variable "sg_id" {
  type = string
  default = "sg-0ff56c6020c4aff70"
}

variable "iam_name" {
  type = string
  default = "ec2_for_efs_s3_cloudwatch"
}

variable "vpc_id" {
  type = string
  default = "vpc-66901d03"
}

variable "subnet_d_id" {
  type = string
  default = "subnet-0ace5ac2c0711268e"
}

variable "subnet_a_id" {
  type = string
  default = "subnet-04ac6c682bf80de34"
}
