output "db_name" {
    value = aws_db_instance.mysql.db_name
    description = "The database name."
}

output "address" {
    value = aws_db_instance.mysql.address
    description = "Connect to the database at this endpoint."
}

output "port" {
    value = aws_db_instance.mysql.port
    description = "The port the database is listening on."
}