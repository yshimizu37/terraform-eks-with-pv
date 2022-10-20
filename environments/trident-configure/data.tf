data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket = var.bucket
    key    = "eks/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

data "terraform_remote_state" "fsxn" {
  backend = "s3"

  config = {
    bucket = var.bucket
    key    = "fsxn/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

data "terraform_remote_state" "trident" {
  backend = "s3"

  config = {
    bucket = var.bucket
    key    = "trident-install/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
