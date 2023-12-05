resource "aws_vpc" "project" {
  cidr_block           = var.cidr_range
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.vpc_name}-vpc"
  }
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.project.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name      = "${var.vpc_name}-public-${var.availability_zones[count.index]}"
    ManagedBy = "Terraform"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.project.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name      = "${var.vpc_name}-private-${var.availability_zones[count.index]}"
    ManagedBy = "Terraform"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.project.id

  tags = {
    Name      = "${var.vpc_name}-igw"
    ManagedBy = "Terraform"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.project.id

  tags = {
    Name      = "${var.vpc_name}-public"
    ManagedBy = "Terraform"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "public_igw" {
  count                  = length(aws_subnet.public)
  route_table_id         = element(aws_route_table.public[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table" "private" {
  count = length(var.private_subnets)
  vpc_id = aws_vpc.project.id

  tags = {
    Name      = "${var.vpc_name}-nat-${var.availability_zones[count.index]}"
    ManagedBy = "Terraform"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(aws_route_table.private[*].id, count.index)
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.public_subnets)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name      = "${var.vpc_name}-nat-${var.availability_zones[count.index]}"
    ManagedBy = "Terraform"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "nat" {
  count  = length(var.public_subnets)
  domain = "vpc"

  tags = {
    Name      = "${var.vpc_name}-eip-${var.availability_zones[count.index]}"
    ManagedBy = "Terraform"
  }
}

resource "aws_route" "private_nat" {
  count                  = length(aws_subnet.private)
  route_table_id         = element(aws_route_table.private[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nat[*].id, count.index)
}

resource "aws_route_table_association" "nat_association" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private[count.index].id
}