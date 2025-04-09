data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["099720109477"]
    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
}

resource "aws_instance" "host_bastion" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type_bastion
    subnet_id = var.public_subnet_ids[0]
    key_name = var.host_key
    vpc_security_group_ids = [var.bastion_sg_id]

    instance_market_options {
      market_type = "spot"
    }

    tags = {
        Name = "host_bastion"
    }
}