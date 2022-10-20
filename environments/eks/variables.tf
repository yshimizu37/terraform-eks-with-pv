//----------
//EKS control plane
//----------

//クラスタをデプロイするリージョン名
variable "aws_region" {
  default = "ap-northeast-1"
}

//クラスタ名
variable "cluster_name" {
  default = "cluster1"
}

//k8sバージョン
variable "k8s_version" {
  default = "1.22"
}

//クラスタが利用する既存サブネットID
variable "subnet_ids" {
  default = [
    "subnet-02e13b4424821078e",
    "subnet-0b7cbc2489615367a"
  ]
}

//----------
//EKS node group
//----------
//ノードグループの名前
variable "node_group_name" {
  default = "ng1"
}

//ノードグループ内のノード数
variable "ng_desired_size" {
  default = 2
}

//ノードグループ内の最大ノード数
variable "ng_max_size" {
  default = 2
}

//ノードグループ内の最小ノード数
variable "ng_min_size" {
  default = 2
}

//ノードグループアップデート時などの最大ノード停止許容数
variable "ng_max_unavailable" {
  default = 1
}
