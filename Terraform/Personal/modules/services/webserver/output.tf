output "tags" {
    value = var.tags
}

output "instance_arn" {
    value = aws_instance.personal.arn
}