terraform {
    backend "s3" {
        bucket = "personal-practice-bucket"
        key = "stage/data-stores/mysql/terraform.tfstate"
        region = "ap-northeast-1"
        dynamodb_table = "terraform-locks"
        encrypt = true
    }
}