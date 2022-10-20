//----------
//FSxN filesystem
//----------

//FSxNをデプロイするリージョン名
variable "aws_region" {
  default = "ap-northeast-1"
}

//FSxNが利用する既存サブネットID
variable "subnet_ids" {
  default = [
    "subnet-02e13b4424821078e",
    "subnet-0b7cbc2489615367a"
  ]
}

//上記サブネットのうち、優先的に利用するサブネットID
variable "preferred_subnet_id" {
    default = "subnet-02e13b4424821078e"
}

//filesystemの管理者パスワード
variable "fsx_admin_password" {
    default = "P@ssw0rd"
}