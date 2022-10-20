locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: "${module.eks_cluster.endpoint}"
    certificate-authority-data: "${module.eks_cluster.kubeconfig-certificate-authority-data}"
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: aws
      args:
      - eks
      - get-token
      - --cluster-name
      - "${module.eks_cluster.cluster_name}"
KUBECONFIG
}

output "kubectl_config" {
  value = "${local.kubeconfig}"
}

output "cluster_name" {
  value = module.eks_cluster.cluster_name
}

output "endpoint" {
  value = module.eks_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = module.eks_cluster.kubeconfig-certificate-authority-data
}

output "token" {
  value = module.eks_cluster.token
  sensitive = true
}