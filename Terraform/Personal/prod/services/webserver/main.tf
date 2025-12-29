module "module_server" {
    source = "../../../modules/services/webserver"
    count = 2
    server_name = "module_server_${count.index}"
    db_remote_state_bucket = "personal_practice_bucket"
    db_remote_state_key = "prod/services/webserver/terraform.tfstate"
}