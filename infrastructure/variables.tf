variable "location" {}
variable "prefix" {}
variable "environment" {}
variable "acr_name" {}
variable "aks_node_count" { type = number; default = 2 }
variable "aks_node_size" { type = string; default = "Standard_DS2_v2" }
variable "kubernetes_version" { type = string; default = "" }
