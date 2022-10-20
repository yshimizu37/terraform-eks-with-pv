//----------
//Provider
//----------
provider "aws" {
  region     = var.aws_region
}

//----------
//S3 bucket
//----------
resource "aws_s3_bucket" "remote_tf" {
  bucket = var.bucket
  force_destroy = true
}
