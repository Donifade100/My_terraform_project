module "mola-eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.3.1"

  name = "mola-eks-cluster"
  kubernetes_version = "1.33"
  endpoint_public_access  = true

  subnet_ids = module.mola-vpc.private_subnets
  vpc_id = module.mola-vpc.vpc_id

  enable_cluster_creator_admin_permissions = true  

  addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    vpc-cni                = {
      before_compute = true
    }
  }
  
  tags = {
    environment = "development"
    application = "mola"
  }

  eks_managed_node_groups = {
    dev = {
        instance_types = ["t2.small"]
        ami_type       = "AL2023_x86_64_STANDARD"
        min_size       = 1
        max_size       = 3
        desired_size   = 3
    }
  }
}
