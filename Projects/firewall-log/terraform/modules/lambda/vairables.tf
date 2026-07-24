variable "function_name" {
  description = "The name of the Lambda function."
  type        = string
}

variable "runtime" {
  description = "The runtime environment for the Lambda function."
  type        = string
  default     = "python3.14"
}

variable "handler" {
  description = "The function within your code that Lambda calls to begin execution."
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "role_arn" {
  description = "The Amazon Resource Name (ARN) of the IAM role that Lambda assumes when it executes your function."
  type        = string
}

variable "filename" {
    description = "The name of the deployment package file."
    type        = string
}

variable "memory_size" {
  description = "The amount of memory available to the function at runtime."
  type        = number
  default     = 1024
}

variable "timeout" {
  description = "The amount of time that Lambda allows a function to run before stopping it."
  type        = number
  default     = 300
}

variable "environment_variables" {
  description = "A map of environment variables to set for the Lambda function."
  type        = map(string)
  default     = {}
}

variable "architectures" {
  description = "The instruction set architecture that the function supports."
  type        = string
  default     = "x86_64"
}

