resource "aws_s3_bucket" "terraform_state" {
  bucket = "personal-practice-bucket"

  #Save terraform state files
resource "aws_s3_bucket" "akira-bucket" {
    bucket = "akira.bucket"

}

  tags = {
    Name        = "My bucket"
  }
  lifecycle {
    prevent_destroy = true
  }    
}