variable "location" {}
variable "resource_group_name" {}
variable "prefix" {}
variable "aks_node_count" { type = number; default = 2 }
variable "aks_node_size" { type = string; default = "Standard_DS2_v2" }
variable "kubernetes_version" { type = string; default = "" }
variable "acr_id" { type = string }
variable "log_analytics_workspace_id" { type = string }
