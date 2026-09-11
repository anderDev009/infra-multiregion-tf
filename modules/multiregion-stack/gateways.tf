
#elastic ip para salida de subred privada
resource "aws_eip" "nat" {
    domain = "vpc"
}
#nat gw
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public[0].id
  depends_on = [ aws_internet_gateway.this ]
}
#gateway a internet
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.vpc.id
}

