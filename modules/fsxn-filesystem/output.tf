output "filesystem_id" {
  value = aws_fsx_ontap_file_system.aws-fsx01.id
}

output "management_dns_name" {
  value = aws_fsx_ontap_file_system.aws-fsx01.endpoints[0].management[0].dns_name
}

output "fsx_admin_password" {
  value = var.fsx_admin_password
}
