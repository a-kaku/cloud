resource "aws_lambda_function" "this" {
  function_name = var.function_name
  runtime       = var.runtime
  handler       = var.handler
  role          = var.role_arn
  filename      = var.filename
  memory_size   = var.memory_size
  timeout       = var.timeout
  environment {
    variables = var.environment_variables
  }
  architectures = [var.architectures]

  source_code_hash = filebase64sha256(var.filename)
}