variable "environment" {
  type = string
}

variable "prefix" {
  type = string
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "owner" {
  type    = string
  default = "sudhir"
}

variable "rg_name" {
  type = string
}

variable "aks_cluster_name" {
  type = string
}

variable "aks_node_size" {
  type    = string
  default = "Standard_B4ms"
}

variable "aks_node_count" {
  type    = number
  default = 1
}

variable "kubernetes_version" {
  type    = string
  default = "1.28.9"
}
