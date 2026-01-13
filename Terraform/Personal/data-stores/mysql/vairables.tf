variable "db_username" {
  description = "The username for MySQL."
  type = string
  sensitive = true
}

variable "db_password" {
    description = "The password for MySQL."
    type = string
    sensitive = true
}