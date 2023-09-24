resource "aws_nat_gateway" "gw1" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.public-subnet-1.id

  tags = {
    Name = "NAT GW1"
  }
}
resource "aws_nat_gateway" "gw2" {
  allocation_id = aws_eip.nat2.id
  subnet_id     = aws_subnet.public-subnet-2.id

  tags = {
    Name = "NAT GW2"
  }
}