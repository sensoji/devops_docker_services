provider "aws" {
    region = "us-east-1"
}

variable "sg_rules" {
    default = {
        "ssh" = {
            type = "ingress"
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr = ["0.0.0.0/0"]
        },
        "http" = {
            type = "ingress"
            from_port = 80
            to_port = 80
            protocol = "tcp"
            cidr = ["0.0.0.0/0"]
        },
        "out_all" = {
            type = "egress"
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr = ["0.0.0.0/0"]
        }
    }
}

data "aws_vpc" "default" {
    default = true
}

resource "aws_key_pair" "deployer" {
    key_name = "deployer"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDkq/44Rqmv14uTq10SaKFT2XUeJzgV107szWgpwgOHvfNmxaHtizB8GIUJ1qKYHWF1Hsrd60hXHKzyRdsNQ3KS7B5+TxR8n96arupC4kMBj8lP3iB4VlBEWClWQF4j2zrDHhcsBcVAX93wXAvIAvu/hpChpGPcus2UN0CsB+iO7D8bqJXiZfqR5t7rTBOxcTar1LCpLpgSWacAj1ZIQZfy1DjD6y7I2eCPwkph47Cxohck/Lq6z7/q16E6JqzYxaABQwgkUuu3KYPYrTSctXRcvdFkViMBOV1SKdGX5vKpM2LrXViU+k6yuw/r2RHPTZth2iSmTmowosiH3y9meLWP+F7yR7hTLtZIcOmmboTB08X+FWsz2AIn586tuPoIy4uvmm2Hu5+AzOqaER/kIPCflixY+WGkUUcCfKe8XrUxjMO0H4f92hgD/xyBjomX42plM0VLosIUNztGp2jZXrzemBoFAB/ZhE8wR831jaqNaAXfL4rbK/XGNkKGRBtNuhE= senso@devops"
}

resource "aws_security_group" "web_sg" {
    name = "webserver_sg"
    description = "allow"
    vpc_id = data.aws_vpc.default.id 
}

resource "aws_security_group_rule" "web_sg_rule" {
    for_each = var.sg_rules
    type = each.value.type
    from_port = each.value.from_port
    to_port = each.value.to_port
    protocol = each.value.protocol
    cidr_blocks = each.value.cidr
    security_group_id = aws_security_group.web_sg.id
}

resource "aws_instance" "webserver" {
    ami = "ami-04505e74c0741db8d"
    instance_type = "t2.micro"
    key_name = aws_key_pair.deployer.key_name
    vpc_security_group_ids = [aws_security_group.web_sg.id]
    tags = {
      Name = "webserver-test-1"
    }
}

output "webserver_ip" {
    value = aws_instance.webserver.public_ip
}