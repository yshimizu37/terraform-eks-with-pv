variable "subnet_ids" {}
variable "preferred_subnet_id" {}
variable "fsx_admin_password" {}

resource "aws_fsx_ontap_file_system" "aws-fsx01" {
  storage_capacity    = 1024
  subnet_ids          = var.subnet_ids
  deployment_type     = "MULTI_AZ_1"
  throughput_capacity = 512
  preferred_subnet_id = var.preferred_subnet_id
  fsx_admin_password  = var.fsx_admin_password
}

