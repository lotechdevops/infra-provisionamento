resource "aws_internet_gateway" "demo_igw" {
  vpc_id = var.vpc_demo_id


  tags = {
    Name = var.igw_name
  }
}