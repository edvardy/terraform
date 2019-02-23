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
MIIC5zCCAc+gAwIBAgIQRtwBMxW4vI9G5QU1heqK1jANBgkqhkiG9w0BAQsFADAW
MRQwEgYDVQQDDAtQMlNSb290Q2VydDAeFw0xOTAyMjMyMjIxNDBaFw0yMDAyMjMy
MjQxNDBaMBYxFDASBgNVBAMMC1AyU1Jvb3RDZXJ0MIIBIjANBgkqhkiG9w0BAQEF
AAOCAQ8AMIIBCgKCAQEAz/I8/HVMYlFOQnW3LcxtV4qkpqPwxdXO/HYtwrT6lO/1
FpNZTpHAN3nQbaHxt7O06JoCQBYMmB74CoGcF68kau8vJKMURStuNUaUjXgU1RMi
0k/eesNn2FzRBQz6jNiTq1Ofi3Myxl3cKtOQGvtE9AuV9fqxzGEFsvp2ZzNZlhgk
pmHC+NuxOtRO8SHW1WNH92YrVYM+l0plopw0+r/ALtw0zV/AzkdIUju7Ugw4to1I
ZwxbcWzo+hmq62IjzQr9oehPkiqc86fLckuHvlCOucQ8ufykGQTwLzJ8VBSX7Igg
e+y77SxrfiSgeI5YAmc9E5DalaD3rGAjAQFv+xhGYQIDAQABozEwLzAOBgNVHQ8B
Af8EBAMCAgQwHQYDVR0OBBYEFPfYLC18gKsYkcGTBDabXIomHJdpMA0GCSqGSIb3
DQEBCwUAA4IBAQBhnUVMiE14BpMVh2uiQcXfd8xSDbERWo03NW3ovEY+pQ3OTJJQ
4/qx57Fkue7Nl6qQfWQNcCVTMcmAVCSkt7IE1UviVyeqGH/7uoJ8X/bQhEqX6Lp+
w7Lzr0ePV5CP8biTUG1Mkkg4BOh701X5dzbMc4GSCfqUv1tesbfaZtaGpsOECDng
VJPTqauIp0bq/+AkPmeyao32CEphBRAkF5pMwxO239GthFl7W1WbO23Mocf60DxF
luh58Yb7AXy8FV1lTBv+VRa4pKWCPNYcCX0gFXcNv0ex7R5MsEx00NcM4fKJOtWV
ODUEILV+zr8xuoI5LMrRSYI8CWyAC4B+u+3a
EOF
    }

    vpn_client_protocols = [ "SSTP" ]

    revoked_certificate {
      name       = "Verizon-Global-Root-CA"
      thumbprint = "912198EEF23DCAC40939312FEE97DD560BAE49B1"
    }
  }
}
