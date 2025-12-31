output "tags" {
    value = values(module.module_server)[*].instance_type
}