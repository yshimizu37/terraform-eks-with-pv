output "management_dns_name" {
  value = module.fsxn_filesystem.management_dns_name
}

output "admin_password" {
  value = module.fsxn_filesystem.fsx_admin_password
}

output "svm_name" {
  value = module.fsxn_svm.svm_name
}
