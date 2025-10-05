provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "mola-vpc" {
    cidr_block = var.vpc_cidr_block
    tags ={
        Name: "${var.env_prefix}-vpc"
    }
}

module "mola-subnet" {
    source = "./modules/subnet"
    subnet_cidr_block = var.subnet_cidr_block
    avail_zone = var.avail_zone
    env_prefix = var.env_prefix
    vpc_id = aws_vpc.mola-vpc.id
    default_route_table_id = aws_vpc.mola-vpc.default_route_table_id
}