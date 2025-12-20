provider "aws" {
    region = "ap-northeast-1"
}

resource "aws_instance" "personal" {

    instance_type = "t2.micro"
    ami = "ami-040573aabcd4f9b69"
    vpc_security_group_ids = [aws_security_group.sg.id]

    tags = {
        Name = "PersonalServer001"
    }
}

resource "aws_security_group" "sg" {
    name = "launch-wizard-1"

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

output "ip" {
    value = aws_instance.PersonalServer001.public_ip
}