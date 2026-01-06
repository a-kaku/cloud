output "instance_ids" {
  description = "The IDs of the EC2 instances."
  value       = {
    sftp_01 = aws_instance.sftp_01.id
    sftp_02 = aws_instance.sftp_02.id
  }
}