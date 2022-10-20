//----------
//Remote bucket
//----------

//バケットをデプロイするリージョン名
variable "aws_region" {
  default = "ap-northeast-1"
}

//リモートにtfstateを保存する為のS3バケット名
variable "bucket" {
  default = "remote-tf-20221019"
}