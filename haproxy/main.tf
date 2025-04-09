data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["099720109477"]
    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
}

resource "aws_instance" "haproxy" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type_haproxy
    subnet_id =  var.subnet_public
    key_name = var.host_key
    vpc_security_group_ids = [var.haproxy_sg_id]

    instance_market_options {
      market_type = "spot"
    }

    tags = {
        Name = "haproxy"
    }


}