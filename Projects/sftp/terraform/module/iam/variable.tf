variable "iam_role_name" {
  type = string
  default = "h21.sftp-EC2"
}

variable "iam_policies" {
    type = map(any)
    default = {
        "AmazonEC2ReadOnlyAccess" = {
            type = "AWS managed"
            policy = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
        }
        "AmazonElasticFileSystemClientReadWriteAccess" = {
            type = "AWS managed"
            policy = "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientReadWriteAccess"
        }
        "AmazonSSMManagedInstanceCore" = {
            type = "AWS managed"
            policy = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
        }
        "CloudWatchAgentServerPolicy" = {
            type = "AWS managed"
            policy = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
        }
        "AmazonEC2ReadOnlyAccess" = {
            type = "AWS managed"
            policy = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
        }
    }
}

variable "CmBillingGroup" {
    description = "The CM billing group for tagging the IAM role"
    type = string
    default = "h21local"
}