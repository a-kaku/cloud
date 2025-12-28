terraform {
    backend "s3" {
        bucket = "${var.}"
        region = "ap-northeast-1"
        key = "terraform.tfstate"

        dynamodb_table = "terraform-locks"
        encrypt = true 
    }
}