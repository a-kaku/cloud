resource "aws_s3_bucker" "terraform_state" {
  bucket = "personal-practice-bucket"

  #Save terraform state files

  tags = {
    Name        = "My bucket"
  }
  lifecycle {
    prevent_destroy = true
  }    
}