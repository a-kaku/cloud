variable "instances" {
  description = "Variables for EC2 instances."
  type = map(any)
  default = {
    "sftp-01" = {}
    "sftp-02" = {}
  }
}