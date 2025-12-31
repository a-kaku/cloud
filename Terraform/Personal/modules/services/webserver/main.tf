resource "aws_instance" "personal" {

    instance_type = "t2.micro"
    ami = "ami-040573aabcd4f9b69"
    
    vpc_security_group_ids = [
        aws_security_group.sg.id
    ]

    tags = {
        Name = "${var.server_name}"
    }
}

resource "aws_security_group" "sg" {
    name = "${var.server_name}-sg"
    description = "Allows apps connect to internet."

    dynamic "ingress" {
        for_each = var.ingress_rule
        content {
          from_port = var.ingress_rule.value.from_port
          to_port = var.ingress_rule.value.to_port
          protocol = var.ingress_rule.value.protocol
          cidr_blocks = var.ingress_rule.value.cidr_blocks
        }
    }

    dynamic "egress" {
        for_each = var.egress_rule
        content {
          from_port = var.egress_rule.value.from_port
          to_port = var.egress_rule.value.to_port
          protocol = var.egress_rule.value.protocol
          cidr_blocks = var.egress_rule.value.cidr_blocks
        }
    }
}

data "aws_subnet" "main" {
  vpc_id     = "vpc-04203f9598b6c66bd"
  cidr_block = "172.31.0.0/20"
}

