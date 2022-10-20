variable "filesystem_id" {}

resource "aws_fsx_ontap_storage_virtual_machine" "fsxn_svm1" {
  file_system_id = var.filesystem_id
  name           = "svm1"
}
