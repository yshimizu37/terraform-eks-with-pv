variable "subnet_ids" {}
variable "preferred_subnet_id" {}
variable "fsx_admin_password" {}
variable "throughput_capacity" {}
variable "deployment_type" {}
variable "storage_capacity" {}

resource "aws_fsx_ontap_file_system" "aws-fsx01" {
  storage_capacity    = var.storage_capacity
  subnet_ids          = var.subnet_ids
  deployment_type     = var.deployment_type
  throughput_capacity = var.throughput_capacity
  preferred_subnet_id = var.preferred_subnet_id
  fsx_admin_password  = var.fsx_admin_password
}

