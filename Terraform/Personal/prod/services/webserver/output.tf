output "all_arns" {
  value = values(module.module_server)[*].instance_arn
}