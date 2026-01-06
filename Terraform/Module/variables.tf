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