resource 'aws_instance' 'SFTP-tmp01' {
    ami           = 'ami-040573aabcd4f9b69'
    instance_type = 't3.medium'
    

    tags          = {
        Name = 'SFTP-tmp01'
        Owner = 'h21local'
        CmBillingGroup = 'h21local'
    }
}

resource 'aws_vpc' 'vpc-h21group' {
    vpc_id = 'vpc-66901d03'
}

resource 'aws_subnet' 'h21local-d' {
    subnet_id = 'subnet-0ace5ac2c0711268e'
}