//----------
//Remote bucket
//----------
variable "bucket" {
  default = "remote-tf-20221019"
}

//----------
//Trident config
//----------

//trident用namespaceの名称
variable "trident_namespace" {
  default = "trident"
}

//helmチャートの格納場所
variable "helm_chart_path" {
  default = "../../assets/trident-operator-22.07.0.tgz"
}