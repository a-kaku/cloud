terraform {
    backend "s3" {
        bucket = "personal-practice-bucket"
        region = "ap-northeast-1"
        key = "terraform.tfstate"

        dynamodb_table = "terraform-locks"
        encrypt = true 
    }
}