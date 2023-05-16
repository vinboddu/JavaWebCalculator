# vpc
resource "aws_vpc" "terra" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "terra"
  }
}
# internet gateway
resource "aws_internet_gateway" "terra-it" {
  vpc_id = aws_vpc.terra.id

  tags = {
    Name = "terra-it"
  }
}
# subnet
resource "aws_subnet" "terra-sub-a" {
  vpc_id     = aws_vpc.terra.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "terra-sub-a"
  }
}

# subnet 
resource "aws_subnet" "terra-sub-b" {
  vpc_id     = aws_vpc.terra.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "terra-sub-b"
  }
}

# route table
resource "aws_route_table" "terra-rt" {
  vpc_id = aws_vpc.terra.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra-it.id
  }


  tags = {
    Name = "terra-rt"
  }
}

# association
resource "aws_route_table_association" "terra-a" {
  subnet_id      = aws_subnet.terra-sub-a.id
  route_table_id = aws_route_table.terra-rt.id
}

resource "aws_route_table_association" "terra-b" {
  subnet_id      = aws_subnet.terra-sub-b.id
  route_table_id = aws_route_table.terra-rt.id
}
