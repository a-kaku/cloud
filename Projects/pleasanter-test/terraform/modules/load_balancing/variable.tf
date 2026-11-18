variable "target_group_name" {
    type = string
}

variable "vpc_id" {
  description = "The VPC ID where the LB and target group will be created."
  type        = string
}

variable "instance_id" {
    type = string
}

variable "lb_arn" {
  type    = string
}

variable "lb_name" {
  type    = string
}

variable "listener_80_arn" {
  type = string
}

variable "listener_443_arn" {
  type = string
}