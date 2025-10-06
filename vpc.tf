provider "aws" {
    region = "us-east-1"
}

variable vpc_cidr_block {}
variable private_subnet_cidr_blocks {}
variable public_subnet_cidr_blocks {}

data "aws_availability_zones" "azs" {}

module "mola-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.4.0"
  
  name = "mola-vpc"
  cidr = var.vpc_cidr_block
  public_subnets = var.public_subnet_cidr_blocks
  private_subnets = var.private_subnet_cidr_blocks
  azs = data.aws_availability_zones.azs.names

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/mola-eks-cluster" = "shared"
  }

  public_subnet_tags = {
      "kubernetes.io/cluster/mola-eks-cluster" = "shared"
      "kubernetes.io/role/elb" = 1
    }

  private_subnet_tags = {
      "kubernetes.io/cluster/mola-eks-cluster" = "shared"
      "kubernetes.io/role/internal-elb" = 1
    }
}