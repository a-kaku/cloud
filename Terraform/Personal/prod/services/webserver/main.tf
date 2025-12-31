module "module_server" {
    #This is a practice for module and count.
    source = "../../../modules/services/webserver"
    for_each = toset(var.users)
    server_name = "module_server_${each.value}"
    db_remote_state_bucket = "personal_practice_bucket"
    db_remote_state_key = "prod/services/webserver/terraform.tfstate"

    ingress_rule = [
        {
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = "0.0.0.0/0"
        },
        {
            from_port = 443
            to_port = 443
            protocol = "tcp"
            cidr_blocks = "0.0.0.0/0"
        }
    ]

    egress_rule = [
        {
            from_port = 0
            to_port = 0
            protocol = -1
            cidr_blocks = "0.0.0.0/0"
        }
    ]

    tags = {
        ManagedBy = "terraform"
        number = "foreach_${each.value}"
    }
}