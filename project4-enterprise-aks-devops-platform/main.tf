erraform {
  required_version = "~> 1.13.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Optional backend declaration (commented since using -backend=false in CI)
# backend "azurerm" {
#   resource_group_name  = "rg-devsecops-state"
#   storage_account_name = "tfstatebackend001"
#   container_name       = "tfstate"
#   key                  = "aks.terraform.tfstate"
# }

