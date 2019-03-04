/* Configure Azure Provider and declare all the Variables that will be used in Terraform configurations */
provider "azurerm" {}

variable "location" {
  description = "The default Azure region for the resource provisioning"
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "Resource group name that will contain various resources"
  default     = "LBDevTestLabRG"
}
