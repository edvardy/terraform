##################################################
# Variables
##################################################
variable "common_tags" {
  type = "map"

  default = {
    "Terraform" = true
    "Project"   = "lab"
  }
}

variable "costcenter" {
  default = ""
}

variable "available_regions" {
  default = ["westeurope"]
}

variable "environment" {
  default = "poc"
}

variable "location" {
  default = "westeurope"
}

variable "storage_account_name" {
  default = "atradiusstatec32e842bf06"
}

variable "global_resource_group_name" {
  default = "global-storage-rg"
}

##################################################
# Local(s)
##################################################
locals {
  costcenter          = "${coalesce(upper(var.costcenter), "ITS")}"
  prefix              = "${var.environment}-${var.location}"
  resource_group_name = "${var.global_resource_group_name}"

  tags = "${merge(
    var.common_tags,
    map(
      "Costcenter", "${local.costcenter}",
      "Environment", "${var.environment}"
    )
  )}"
}
