module "module_server" {
    #This is a practice for module and count.
    source = "../../../modules/services/webserver"
    for_each = toset(var.users)
    server_name = "module_server_${each.value}"
    db_remote_state_bucket = "personal_practice_bucket"
    db_remote_state_key = "prod/services/webserver/terraform.tfstate"
}

resource "aws_iam_user" "loop" {
    for_each = toset(var.users)
    name = each.value
}