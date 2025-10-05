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

module "mola-app-server" {
    source = "./modules/web-server"
    avail_zone = var.avail_zone
    env_prefix = var.env_prefix
    my_ip = var.my_ip
    instance_type = var.instance_type
    public_key_location = var.public_key_location
    vpc_id = aws_vpc.mola-vpc.id
    image_name= var.image_name
    subnet_id = module.mola-subnet.id
}