//----------
//Remote bucket
//----------
variable "bucket" {
  default = "remote-tf-20221019"
}

//----------
//Trident config
//----------

//FSxN認証情報を格納したSecretの名称
variable "fsxn_secret_name" {
  default = "fsxn-secret"
}

//Trident Backend Configリソースの名称
variable "fsxn_backend_config_name" {
  default = "fsxn-backend-nas-config"
}

//Trident Backendリソースの名称
variable "fsxn_backend_name" {
  default = "fsxn-backend-nas"
}

//StorageClassリソースの名称
variable "fsxn_storage_class_name" {
  default = "fsxn-nas"
}