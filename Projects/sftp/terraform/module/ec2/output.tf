output "instance_ids" {
  description = "The IDs of the EC2 instances."
  value       = {
    for k, v in aws_instance.sftp_instance :
        k => v.id
  }
}