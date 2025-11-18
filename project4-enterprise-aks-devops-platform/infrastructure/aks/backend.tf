terraform {
  backend "azurerm" {
    resource_group_name   = "rg-devsecops-dev"
    storage_account_name  = "tfstate8045"
    container_name        = "tfstate"
    key                   = "aks/terraform.tfstate"
  }
}
