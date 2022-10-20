//----------
//Provider
//----------
provider "aws" {
  region     = var.aws_region
}

//----------
//FSxN config
//----------
module "fsxn_filesystem" {
  source      = "../../modules/fsxn-filesystem/"

  subnet_ids = var.subnet_ids
  preferred_subnet_id = var.preferred_subnet_id
  fsx_admin_password = var.fsx_admin_password
}

module "fsxn_svm" {
  source          = "../../modules/fsxn-svm/"

  filesystem_id     = module.fsxn_filesystem.filesystem_id
}
