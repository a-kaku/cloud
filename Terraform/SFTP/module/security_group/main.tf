resource "aws_security_group" "sg" {
    description = "Allow inbound traffic and all outbound traffic"
    name = var.sg_name
    vpc_id = var.vpc_id

    tags = {
        Name = var.sg_name
        CmBillingGroup = var.cm_billing_group
    }

}

resource "aws_security_group_rule" "ingress" {

    for_each = {
        for idx, rule in var.ingress_rules :
        idx => rule
    }
    type = "ingress"
    from_port = each.value.from_port
    to_port = each.value.to_port
    protocol = each.value.protocol
    security_group_id = aws_security_group.sg.id
    cidr_blocks = each.value.cidr != null ? [each.value.cidr] : null
    source_security_group_id = lookup(each.value, "source_sg", null)
    description = lookup(each.value, "description", null)

}

resource "aws_security_group_rule" "egress" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_group_id = aws_security_group.sg.id
    cidr_blocks = ["0.0.0.0/0"]
}