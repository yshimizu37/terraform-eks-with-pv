//----------
//Provider
//----------
provider "aws" {
  region     = var.aws_region
}

//----------
//EKS config
//----------
module "eks_cluster" {
  source      = "../../modules/eks/"
  
  cluster_name = var.cluster_name
  k8s_version = var.k8s_version
  subnet_ids = var.subnet_ids
  node_group_name = var.node_group_name
  ng_desired_size = var.ng_desired_size
  ng_max_size = var.ng_max_size
  ng_min_size = var.ng_min_size
  ng_max_unavailable = var.ng_max_unavailable
}

