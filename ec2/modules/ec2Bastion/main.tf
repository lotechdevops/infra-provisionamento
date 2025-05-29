data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["099720109477"]
    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
}

resource "aws_instance" "ec2Bastion" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type_bastion
    subnet_id = var.private_subnet_ids
    vpc_security_group_ids = [var.bastion_sg_id]
    key_name = var.key_name

    instance_market_options {
      market_type = var.market_type_instance_bastion
    }

    tags = {
        Name = var.tag_name_instance
    }
}