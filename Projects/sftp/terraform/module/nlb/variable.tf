variable "nlb_name" {
  description = "The name of the Network Load Balancer."
  type        = string
  default     = "nlb-sftp"
}

variable "CmBillingGroup" {
  description = "The billing group to use for the Network Load Balancer."
  type        = string
  default     = "h21local"
}

variable "nlb_tg_tag_name" {
  description = "The name tag for the NLB target group."
  type        = string
  default     = "sftp-nlb-tg"
}

variable "vpc_id" {
  description = "The VPC ID where the NLB and target group will be created."
  type        = string
  default     = "vpc-66901d03"
}

variable "subnet_a_name" {
  type = string
  default = "h21public-a"
}

variable "subnet_d_name" {
  type = string
  default = "h21public-d"
}

variable "eip_allocation_ids" {
  description = "A map of EIP allocation IDs for the NLB subnets."
  type        = map(string)
}

variable "target_instance_ids" {
  description = "EC2 instance IDs for target group attachment"
  type        = map(string)
}

variable "nlb_sg_name" {
  description = "The name of the Network Load Balancer security group"
  type        = string
  default     = "h21sftp-nlb"
}

variable "nlb_config" {
  description = "Configuration for NLB subnets and EIP allocation IDs"
  type = map(object({
    subnet_name   = string
    allocation_id = string
  }))
}