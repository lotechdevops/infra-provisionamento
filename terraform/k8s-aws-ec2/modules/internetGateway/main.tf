resource "aws_internet_gateway" "k8s_igw" {
  vpc_id = var.vpc_k8s


  tags = {
    Name = var.igw_name
  }

}
