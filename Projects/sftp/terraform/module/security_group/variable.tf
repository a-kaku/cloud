variable "sg_name" {
    description = "The name of the security group"
    type = string
    default = "h21sftp"
}

variable "vpc_id" {
    description = "The ID of the VPC where the security group will be created"
    type = string
    default = "vpc-66901d03"
}

variable "cm_billing_group" {
    description = "The CM billing group for tagging the security group"
    type = string
    default = "h21local"
}

variable "ingress_rules" {
    description = "List of ingress rules for the security group"
    type = list(object({
        from_port = number
        to_port = number
        protocol = string
        cidr = optional(string)
        source_sg = optional(string)
        description = optional(string)
    }))

    default = [ 
    {
        from_port = 2049
        to_port = 2049
        protocol = "tcp"
        source_sg = "sg-0f724466d87b9ab49"
        description = "Allow NFS from the EFS security group"
    }
    ]

}
