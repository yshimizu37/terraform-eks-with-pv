data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket = var.bucket
    key    = "eks/terraform.tfstate"
    region = "ap-northeast-1"
  }
}