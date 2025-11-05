variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "acr_name" { type = string }
variable "sku" { type = string; default = "Standard" }

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = false

  georeplications = []
  tags = {
    environment = var.resource_group_name
  }
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}
