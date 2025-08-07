module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.0.0"

  cluster_name                   = local.name
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  node_security_group_tags = {
    "kubernetes.io/cluster/${local.name}" = null
  }

  # https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1986 
  # https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1810

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = "AL2023_x86_64_STANDARD"
    instance_types = ["m5.large"]
    capacity_type  = "SPOT"

    attach_cluster_primary_security_group = true
  }

  eks_managed_node_groups = {
    fastcampus-cluster-ng = {
      min_size     = 2
      max_size     = 5
      desired_size = 3

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"

      tags = {
        environment                           = "staging"
        cluster                               = local.name
        "kubernetes.io/cluster/${local.name}" = "owned" # Required for Cluster Autoscaler
      }
    }
  }

  tags = local.tags
}
