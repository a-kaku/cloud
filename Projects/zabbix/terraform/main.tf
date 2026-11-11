module "ec2" {
    source = "./modules/ec2"

    ami_id = var.ami_id
    instance_type = var.instance_type
    vpc_id = var.vpc_id
}