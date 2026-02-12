resource "aws_dynamodb_table" "this" {

    name = var.dynamodb_table_name
    billing_mode = "PAY_PER_REQUEST"
    hash_key = var.dynamodb_hash_key
    deletion_protection_enabled = true
    attribute {
        name = var.dynamodb_hash_key
        type = "S"
    }

    ttl {
      attribute_name = "expire_at"
      enabled = true
    }

    tags = {
      Name = var.dynamodb_table_name
      CmBillingGroup = var.CmBillingGroup
    }
    
}