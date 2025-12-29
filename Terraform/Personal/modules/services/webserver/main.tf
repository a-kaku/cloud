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

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

data "aws_subnet" "main" {
  vpc_id     = "vpc-04203f9598b6c66bd"
  cidr_block = "172.31.0.0/20"
}