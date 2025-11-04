# ❌ Intentional Violations for DevSecOps Testing
# This file is used to test Checkov + OPA scans in the CI pipeline


# ⚠️ Missing tags + using a public IP = Checkov & OPA violations
resource "azurerm_public_ip" "test_public_ip" {
  name                = "unsecured-public-ip"
  location            = "eastus"
  resource_group_name = "rg-devsecops-dev"
  allocation_method   = "Static"
  sku                 = "Standard"
}

# ⚠️ Network Security Group allowing all inbound traffic (Security Violation)
resource "azurerm_network_security_group" "open_nsg" {
  name                = "open-nsg"
  location            = "eastus"
  resource_group_name = "rg-devsecops-dev"

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
