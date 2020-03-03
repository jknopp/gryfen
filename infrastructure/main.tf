# https://www.terraform.io/docs/backends/types/azurerm.html
terraform {
  backend "azurerm" {}
}

provider "azurerm" {
  version = "=2.0.0"
  features {}
}

resource "azurerm_resource_group" "default" {
  name     = "${var.name}-${var.environment}-rg"
  location = var.location
}