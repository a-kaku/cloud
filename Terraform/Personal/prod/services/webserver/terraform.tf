terraform {
    backend "s3" {
        region = "ap-northeast-1"
        bucket = "personal-practice-bucket"
        key = "prod/services/webserver/terraform.tfstate"
    }
}