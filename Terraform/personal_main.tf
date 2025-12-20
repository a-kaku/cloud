provider "aws" {
    region = "ap-northeast-1"
}

resource "aws_instance" "personal" {
    tags = {
        Name = "PersonalServer001"
    }

    instance_type = "t2.micro"
    ami = "ami-040573aabcd4f9b69"
}