resource "aws_subnet" "mola-subnet-01" {
    vpc_id = var.vpc_id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avail_zone
    tags = {
        Name: "${var.env_prefix}-subnet-01"
    }
}

resource "aws_default_route_table" "main-rtb" {
    default_route_table_id = var.default_route_table_id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.mola-igw.id
    }
    tags = {
      Name: "${var.env_prefix}-main-rtb"
    }

}

resource "aws_internet_gateway" "mola-igw" {
    vpc_id = var.vpc_id
    tags = {
      Name: "${var.env_prefix}-igw"
    }

}