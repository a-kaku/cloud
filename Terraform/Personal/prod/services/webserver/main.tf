provider "aws" {
  region = "ap-northeast-1"
}

module "webserver" {
  source = "../../../modules/services/webserver"
  server_name = "module_test_web"
  db_remote_state_bucket = "personal-practice-bucket" 
  db_remote_state_key = "prod/services/webserver/terraform.tfstate"
}