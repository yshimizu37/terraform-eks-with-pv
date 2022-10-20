//
//リモートにtfstateを保存する為のバックエンド定義
//
terraform {
  backend "s3" {
    //リモートにtfstateを保存する為のS3バケット名
    //environment/s3bucket/variables.tfと一致させる
    bucket = "remote-tf-20221019"
    key    = "trident-install/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
