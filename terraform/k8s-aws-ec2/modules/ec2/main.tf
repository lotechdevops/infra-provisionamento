data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["099720109477"]
    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
}

resource "aws_instance" "k8s_master" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type_master
    subnet_id = var.private_subnet_ids[0]
    vpc_security_group_ids = [var.sg_master_id]
    key_name = var.host_key
    

    instance_market_options {
      market_type = "spot"
    }

    tags = {
        Name = "k8s_master"
    }
}

resource "aws_instance" "k8s_workers" {
  count = var.worker_count
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type_worker
  subnet_id = var.private_subnet_ids[0]
  vpc_security_group_ids = [var.sg_nodes_id]
  key_name = var.host_key

  instance_market_options {
    market_type = "spot"
  }

  tags = {
    Name = "k8s_worker_${count.index + 1}"
  }
}