# 🚨 This file intentionally contains misconfigurations
# Used to test Checkov + OPA security scanning in the DevSecOps pipeline

# Input variable for dynamic environment suffix
variable "env" {
  description = "Environment name (dev, preprod, prod)"
  type        = string
}

# ⚠️ Missing tags + using a public IP (Checkov + OPA violation)
resource "azurerm_public_ip" "test_public_ip" {
  name                = "unsecured-public-ip-${var.env}"
  location            = "eastus"
  resource_group_name = "rg-devsecops-${var.env}"
  allocation_method   = "Static"    # Standard SKU requires Static allocation
  sku                 = "Standard"  # Fixed Azure Basic limit
}

# ⚠️ NSG allowing all inbound traffic (Checkov + OPA violation)
resource "azurerm_network_security_group" "open_nsg" {
  name                = "open-nsg-${var.env}"
  location            = "eastus"
  resource_group_name = "rg-devsecops-${var.env}"

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
}

