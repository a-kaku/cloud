terraform {
    backend "s3" {
        region = "ap-northeast-1"
        bucket = "${var.db_remote_bucket}"
        key = "${var.db_remote_state_key}"

        dynamodb_table = "terraform-locks"
        encrypt = true 
    }
}