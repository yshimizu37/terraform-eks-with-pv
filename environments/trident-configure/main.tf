//----------
//Provider
//----------
provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.kubeconfig-certificate-authority-data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.eks.outputs.cluster_name]
    command     = "aws"
  }
}

//----------
//Trident setup
//----------
module "trident_configure" {
  source          = "../../modules/trident-configure/"

  trident_namespace = data.terraform_remote_state.trident.outputs.trident_namespace
  fsxn_secret_name = var.fsxn_secret_name
  fsxn_admin_password = data.terraform_remote_state.fsxn.outputs.admin_password
  fsxn_backend_config_name = var.fsxn_backend_config_name
  fsxn_backend_name = var.fsxn_backend_name
  fsxn_management_dns_name = data.terraform_remote_state.fsxn.outputs.management_dns_name
  fsxn_svm_name = data.terraform_remote_state.fsxn.outputs.svm_name
  fsxn_storage_class_name = var.fsxn_storage_class_name
}
