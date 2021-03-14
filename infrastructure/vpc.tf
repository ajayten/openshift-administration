resource "aws_vpc" "vpc" {
  cidr_block                       = "10.250.0.0/16"
  enable_dns_hostnames             = true

  tags = {
    Name = "Heinlein Training - VPC"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Heinlein Training - Internet Gateway"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Heinlein Training - Public Route Table"
  }
}


resource "aws_subnet" "subnet-public" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = element(data.aws_availability_zones.frankfurt.names, 0)

  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 10)
  map_public_ip_on_launch = true

  tags = {
    Name = "Heinlein Training - Public Subnet"
  }
}

resource "aws_route_table_association" "public-to-rt" {
  subnet_id      = aws_subnet.subnet-public.id
  route_table_id = aws_route_table.public-rt.id
}