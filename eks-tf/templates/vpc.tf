### Availability Of The System ###
data "aws_availability_zones" "highly-available" {}

### VPC ###
resource "aws_vpc" "eks-vpc" {
  cidr_block       = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"
  tags                                           = {
    Name                                         = "${var.cluster_name}-vpc"
    "kubernetes.io/cluster/${var.cluster_name}"  = "shared"
  }
}

### Public Subnets ###
resource "aws_subnet" "eks-public-sub" {
  count = length("${var.public_subnets_range}")
  vpc_id     = "${aws_vpc.eks-vpc.id}"
  cidr_block = "${var.public_subnets_range[count.index]}"
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.highly-available.names[count.index % length(data.aws_availability_zones.highly-available.names)]
  tags = {
    Name = "${var.cluster_name}-public-sub-${count.index +1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }
}

### Private Subnets ###
resource "aws_subnet" "eks-private-sub" {
  count = length("${var.private_subnets_range}")
  vpc_id     = "${aws_vpc.eks-vpc.id}"
  cidr_block = "${var.private_subnets_range[count.index]}"
  availability_zone = data.aws_availability_zones.highly-available.names[count.index % length(data.aws_availability_zones.highly-available.names)]
  tags = {
    Name = "${var.cluster_name}-private-sub-${count.index +1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }
}

### Internet Gateway ###
resource "aws_internet_gateway" "eks-igw" {
  vpc_id = "${aws_vpc.eks-vpc.id}"
  tags = {
    Name = "${var.cluster_name}-igw"
  }
}

### Elastic IP ###
resource "aws_eip" "eks-ngw" {
  vpc = true 
  tags = {
    Name = "${var.cluster_name}-eip"
  }
  }

### NAT Gateway ###
resource "aws_nat_gateway" "eks-ngw" {
  allocation_id = "${aws_eip.eks-ngw.id}"
  subnet_id     = "${aws_subnet.eks-public-sub[0].id}"
  tags = {
    Name = "${var.cluster_name}-ngw"
  }
depends_on = [aws_internet_gateway.eks-igw]
}

### Route Tables Public ##
resource "aws_route_table" "eks-rt-pub" {
  vpc_id = "${aws_vpc.eks-vpc.id}"
  route {
    cidr_block = "${var.public_access_cidr}"
    gateway_id = "${aws_internet_gateway.eks-igw.id}"
  }
  tags = {
    Name = "${var.cluster_name}-eks-rt-pub"
  }
}

### Route Tables Private ###
resource "aws_route_table" "eks-rt-priv" {
  vpc_id = "${aws_vpc.eks-vpc.id}"
  route {
    cidr_block = "${var.public_access_cidr}"
    gateway_id = "${aws_nat_gateway.eks-ngw.id}"
  }
  tags = {
    Name = "${var.cluster_name}-eks-rt-priv"
  }
}

### Route Table Association Public ###
resource "aws_route_table_association" "pub" {
  count = length("${var.public_subnets_range}")
  subnet_id      = "${aws_subnet.eks-public-sub.*.id[count.index]}"
  route_table_id = "${aws_route_table.eks-rt-pub.id}"
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    aws_subnet.eks-public-sub,
    aws_route_table.eks-rt-pub
  ]
}

### Route Table Association Private ###
resource "aws_route_table_association" "priv" {
  count = length("${var.private_subnets_range}")
  subnet_id      = "${aws_subnet.eks-private-sub.*.id[count.index]}"
  route_table_id = "${aws_route_table.eks-rt-priv.id}"
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    aws_subnet.eks-private-sub,
    aws_route_table.eks-rt-priv
  ]
}