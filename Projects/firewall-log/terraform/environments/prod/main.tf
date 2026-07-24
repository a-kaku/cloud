module "firewall_log_lambda" {
    source = "../../modules/lambda"
    function_name = var.function_name
    runtime = var.runtime
    memory_size = var.memory_size
    timeout = var.timeout
    environment_variables = var.environment_variables
    role_arn = var.role_arn
    filename = "../../build/lambda_function.zip"

}