variable "domain_name" {
    description = ""
    type = string
    default = "sftp"
}

variable "type" {
  type = string
  default = "CNAME"
}

variable "hosted_zone_name" {
  type = string
  default = "h21group.com"
}

variable "record" {
  type = string
  default = "nlb-sftp-319703b80cb891d2.elb.ap-northeast-1.amazonaws.com"
}