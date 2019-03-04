resource "azurerm_resource_group" "test" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "test" {
  name                = "test"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "test" {
  name                 = "GatewaySubnet"
  resource_group_name  = "${azurerm_resource_group.test.name}"
  virtual_network_name = "${azurerm_virtual_network.test.name}"
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_public_ip" "test" {
  name                = "test"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"

  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "test" {
  name                = "test"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = "${azurerm_public_ip.test.id}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${azurerm_subnet.test.id}"
  }

  vpn_client_configuration {
    address_space = ["10.2.0.0/24"]

    root_certificate {
      name = "P2SRoot"

      public_cert_data = <<EOF
MIIC5zCCAc+gAwIBAgIQLzM/ndykTbZGwfJ56oyR1DANBgkqhkiG9w0BAQsFADAW
MRQwEgYDVQQDDAtQMlNSb290Q2VydDAeFw0xOTAyMjcxNTI5MjZaFw0yMDAyMjcx
NTQ5MjZaMBYxFDASBgNVBAMMC1AyU1Jvb3RDZXJ0MIIBIjANBgkqhkiG9w0BAQEF
AAOCAQ8AMIIBCgKCAQEAvDOSkVEry+B1KeaL2NhxiJ5heDxua1o9LM9XTzmsvkjG
qPA7TzRRzAQvjHok7hUeqqygLvpdAU/5xJWg2yoySlAbQsvODQdyQpotEs+tKgsJ
fRv7VMTeL1Wml+9O0vVyyXj0nuvnZGhqgR1bfmfHNBWDYXffmpGt5KTPKm1VSPJH
xBz1rwm5ftkzO3zj9OTkLGqStpTdF5PUXwprKebWS8ahZqCQ/zY7oLeqO/B1AKOP
AgIwFSJCgIlgDG3+MLBTMkwKdZ3MJoIXYuqfkPMbLmCxw5mWfk7PmZ9LQirhTEMz
OJ3H3FeEhGE/inwZ9qaPwnBQjFnbSeAFOpPO8CF5/QIDAQABozEwLzAOBgNVHQ8B
Af8EBAMCAgQwHQYDVR0OBBYEFOhavbDW160csC4hUeOkT139mOXYMA0GCSqGSIb3
DQEBCwUAA4IBAQCfBWZZgeczXrqxtjec+d6AYLExSYOo9h6Jyy1T023wEv/0QDld
agPGFAw9uzPBqmpQjsdLdTbjKj0tHe8DEvhuTaCK08lXh7XcbpxZ7pLMjQvPPvK4
JIF96GsL0HFTMTpXgVBhXiCFncu8CqnfXs0At0jXhMCevPk/ZOtjM2WyDkv0L6Ho
OmxwY+8Pcpu7Hgt6hkqjYpTCRV/dvrHBAU2CHCcQOSGp+onbMLYJWnzBm9hLAsh7
5l6oIFkkWpUaN1IXNvtWTfd9aqbKY9JEM/T9MDXbTDdGzokVSOQcqRIu12dUGwSe
JHu98ebztQkCiIk3tDk/8DMthjdF3EJu7kTy
EOF
    }

    vpn_client_protocols = ["SSTP"]

    revoked_certificate {
      name       = "Verizon-Global-Root-CA"
      thumbprint = "912198EEF23DCAC40939312FEE97DD560BAE49B1"
    }
  }
}
