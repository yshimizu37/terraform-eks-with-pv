variable "trident_namespace"{}
variable "fsxn_secret_name"{}
variable "fsxn_admin_password"{}
variable "fsxn_backend_config_name"{}
variable "fsxn_backend_name"{}
variable "fsxn_management_dns_name"{}
variable "fsxn_svm_name"{}
variable "fsxn_storage_class_name"{}

//
//FSxNの認証情報作成
//
resource "kubernetes_secret_v1" "fsx_secret" {
  metadata {
    name = var.fsxn_secret_name
    namespace = var.trident_namespace
  }

  data = {
    username = "fsxadmin"
    password = var.fsxn_admin_password
  }
}

//
//TridentBackendConfig作成
//
resource "kubernetes_manifest" "trident_backend_config" {
  manifest = {
    "apiVersion" = "trident.netapp.io/v1"
    "kind" = "TridentBackendConfig"
    "metadata" = {
      "name" = var.fsxn_backend_config_name
      "namespace" = var.trident_namespace
    }
    "spec" = {
      "backendName" = var.fsxn_backend_name
      "credentials" = {
        "name" = var.fsxn_secret_name
      }
      "managementLIF" = var.fsxn_management_dns_name
      "storageDriverName" = "ontap-nas"
      "svm" = var.fsxn_svm_name
      "version" = 1
    }
  }
  wait {
    fields = {
      "status.phase" = "Bound"
    }
  }
  timeouts {
    create = "30s"
    update = "30s"
    delete = "30s"
  }
  lifecycle {
    prevent_destroy = true
    //ignore_changes = [manifest.metadata]
  }
}

resource "kubernetes_storage_class_v1" "fsx-storage-class" {
  metadata {
    name = var.fsxn_storage_class_name
  }
  storage_provisioner = "csi.trident.netapp.io"
  reclaim_policy      = "Delete"
  parameters = {
    backendType = "ontap-nas"
  }
}
