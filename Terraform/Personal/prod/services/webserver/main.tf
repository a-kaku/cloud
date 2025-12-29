module "module_server" {
    source = "../../../module/services/webserver"
    server_name = "module_server_1"
    db_remote_state_bucket = "personal_practice_bucket"
    db_remote_state_key = "prod/services/webserver/terraform.tfstate"
}