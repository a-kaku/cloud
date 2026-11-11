resource "aws_instance" "ec2" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = data.aws_subnet.subnet_d.id
    key_name = var.key_name
    vpc_security_group_ids = [var.sg_id]
    iam_instance_profile = aws_iam_instance_profile.instance_profile.name

    tags = {
        Name = var.tag_name
        Owner = var.tag_owner
        CmBillingGroup = var.tag_billing_group
    }

    volume_tags = {
        Name = var.tag_name
        CmBillingGroup = var.tag_billing_group
    }
    
     
}

data "aws_vpc" "vpc_object" {
    id = var.vpc_id
}

data "aws_subnet" "subnet_a" {
    id = var.subnet_a_id
}

data "aws_security_group" "sg" {
    id = var.sg_id
}

data "aws_iam_instance_profile" "instance_profile" {
    name = var.iam_name
}