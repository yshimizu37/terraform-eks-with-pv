variable "trident_namespace" {}
variable "helm_chart_path" {}

//
//Tridentインストール
//
resource "helm_release" "trident" {
  name       = "trident"
  namespace  = var.trident_namespace
  chart      = var.helm_chart_path
  create_namespace = true
}
