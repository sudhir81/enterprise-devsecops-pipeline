# 🚨 This file intentionally contains misconfigurations
# Used to test Checkov + OPA security scanning in the DevSecOps pipeline

variable "env" {
  description = "Environment name (dev, preprod, prod)"
  type        = string
}

# ⚠️ Public IP with intentional security violation (Checkov + OPA test)
resource "azurerm_public_ip" "test_public_ip" {
  name                = "unsecured-public-ip-${var.env}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"    # Required for Standard SKU
  sku                 = "Standard"

  # Ensure RG is created before this runs (fixes 404 error)
  depends_on = [
    azurerm_resource_group.rg
  ]
}

# ⚠️ Network Security Group allowing all inbound traffic (intentional violation)
resource "azurerm_network_security_group" "open_nsg" {
  name                = "open-nsg-${var.env}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow_all_inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }

  # Wait for RG creation
  depends_on = [
    azurerm_resource_group.rg
  ]
}

