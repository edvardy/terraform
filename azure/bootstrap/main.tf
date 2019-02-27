##################################################
# Providers
##################################################
provider "terraform" {}

provider "azurerm" {
  environment = "public"
  version     = "~> 1.13"
}

##################################################
# Azure resource group
##################################################
resource "azurerm_resource_group" "main" {
  name     = "${var.global_resource_group_name}"
  location = "${var.location}"

  tags = "${merge(
    var.common_tags,
    map(
      "Costcenter", "${local.costcenter}",
      "Environment", "global"
    )
  )}"
}

##################################################
# Azure storage account
##################################################
resource "azurerm_storage_account" "asa" {
  name                     = "${var.storage_account_name}"
  resource_group_name      = "${azurerm_resource_group.main.name}"
  location                 = "${azurerm_resource_group.main.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  tags                     = "${local.tags}"
}

##################################################
# Azure storage container
##################################################
resource "azurerm_storage_container" "sc" {
  count                 = "${length(var.available_regions)}"
  name                  = "${element(var.available_regions, count.index)}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  storage_account_name  = "${azurerm_storage_account.asa.name}"
  container_access_type = "private"
}
