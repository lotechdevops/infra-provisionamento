data "http" "my_ip" {
  url = "http://ifconfig.me/ip"
}


resource "aws_security_group" "k8s_sg" {
  name = "k8s_sg"
  vpc_id = var.vpc_k8s

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    from_port = 6443
    to_port = 6443
    protocol = "tcp"
    security_groups = [aws_security_group.haproxy_sg.id]
  }

  ingress {
    from_port = 2379
    to_port = 2380
    protocol = "tcp"
    cidr_blocks = ["192.168.0.0/16"]
  }

  ingress {
    from_port = 10250
    to_port = 10250
    protocol = "tcp"
    cidr_blocks = ["192.168.0.0/16"]
  }

  ingress {
    from_port = 10259
    to_port = 10259
    protocol = "tcp"
    cidr_blocks = ["192.168.0.0/16"]
  }

  ingress {
    from_port = 10256
    to_port = 10257
    protocol = "tcp"
    cidr_blocks = ["192.168.0.0/16"]
    }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["192.168.0.0/16"]
  }


  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k8s_sg"
  }

}

resource "aws_security_group" "bastion_sg" {
  name = "bastion_sg"
  vpc_id = var.vpc_k8s

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "${data.http.my_ip.response_body}/32" ]
    }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
      Name = "bastion_sg"
    }

}


resource "aws_security_group" "haproxy_sg" {
  name = "haproxy_sg"
  vpc_id = var.vpc_k8s

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "${data.http.my_ip.response_body}/32" ]
  }

  ingress {
    from_port = 6443
    to_port = 6443
    protocol = "tcp"
    cidr_blocks = [ "${data.http.my_ip.response_body}/32" ]
  }
  
  ingress {
    from_port = 6443
    to_port = 6443
    protocol = "tcp"
    cidr_blocks = ["192.168.0.0/16"]
  }
  

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
      Name = "haproxy_sg"
    }

}