resource "aws_instance" "ec2" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = data.aws_subnet.subnet_d.id
    key_name = var.key_name
    vpc_security_group_ids = [var.sg_id]
    iam

    tags = {
        Name = var.tag_name
        Owner = var.tag_owner
        CmBillingGroup = var.tag_billing_group
    } 
}

data "aws_vpc" "vpc_object" {
    id = var.vpc_id
}

data "aws_subnet" "subnet_a" {
    id = var.subnet_a_id
}

data "aws_iam_role" "iam_role" {
    name = var.iam_name
}

data "aws_security_group" "sg" {
    id = var.sg_id
}