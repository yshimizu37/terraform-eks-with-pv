//----------
//Remote bucket
//----------
variable "bucket" {
  default = "remote-tf-20221019"
}

//----------
//Provider
//----------
provider "helm" {
  kubernetes  {
    host                   = data.terraform_remote_state.eks.outputs.endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.kubeconfig-certificate-authority-data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.eks.outputs.cluster_name]
      command     = "aws"
    }
  }
}

//----------
//Trident setup
//----------
module "trident_install" {
  source      = "../../modules/trident-install/"
  trident_namespace = "trident"
  helm_chart_path = "../../assets/trident-operator-22.07.0.tgz"
}