output "eip_allocation_ids" {
    value = {
    for subnet_id, eip in aws_eip.subnet_eip :
    subnet_id => eip.id
    }
}