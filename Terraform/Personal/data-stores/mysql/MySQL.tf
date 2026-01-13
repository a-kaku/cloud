resource "aws_db_instance" "mysql" {
    engine = "mysql"
    allocated_storage = 10
    instance_class = "db.t2.micro"
    engine_version = "8.0"
    db_name = "personal_db"
    skip_final_snapshot = true
    identifier_prefix = "terraform-up-and-running"

    username = var.db_username
    password = var.db_password
}