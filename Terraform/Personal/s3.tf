resource "aws_s3_bucket" "terraform_state" {
  bucket = "personal-practice-bucket"

  #Save terraform state files

  tags = {
    Name        = "My bucket"
  }
  lifecycle {
    prevent_destroy = true
  }    
}

resource "aws_s3_bucket" "akira-bucket" {
    bucket = "akira.bucket"
}

resource "aws_dynamodb_table" "terraform_locks" {
  name = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

output "se_bucket_arn" {
  value = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the S3 bucket."
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
  description = "The name of the DynamoDB table."
}