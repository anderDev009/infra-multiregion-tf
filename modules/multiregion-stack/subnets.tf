#subredes publicas vpc
resource "aws_subnet" "public" {
  count                   = length(var.avaliability_zones)
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.avaliability_zones[count.index]
  cidr_block              = var.cidr_block[count.index]
  map_public_ip_on_launch = true
}
#subredes privadas
resource "aws_subnet" "private" {
  count             = length(var.avaliability_zones)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.avaliability_zones[count.index]
  cidr_block        = var.cidr_block_private[count.index]
}