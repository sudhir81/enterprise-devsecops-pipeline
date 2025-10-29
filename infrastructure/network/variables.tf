variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region for deployment"
  type        = string
  default     = "eastus"
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "Name of the Subnet"
  type        = string
}

variable "subnet_prefixes" {
  description = "Subnet address range"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    environment = "dev"
    project     = "enterprise-devsecops-pipeline"
    owner       = "SudhirDalvi"
  }
}

