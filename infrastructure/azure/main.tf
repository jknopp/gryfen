# https://www.terraform.io/docs/backends/types/azurerm.html
terraform {
  backend "azurerm" {}
}

provider "azurerm" {
  version = "=2.0.0"
  features {}
}

module "terraformstate" {
  source = "./modules/terraformstate"
  storage_account_name = module.storage.storage_account_name
  terraform_backend_state_container_name = var.terraform_backend_state_container_name
}

module "rg" {
  source = "./modules/resourcegroup"
  name = var.name
  environment = var.environment
  location = var.location
}

module "webapp" {
  source = "./modules/webapp"
  name = var.name
  environment = var.environment
  dns_prefix = var.dns_prefix
  plan_tier = var.plan_tier
  plan_sku = var.plan_sku
  resource_group_name = module.rg.resource_group_name
  resource_group_location = module.rg.resource_group_location
}

module "storage" {
  source = "./modules/storage"
  name = var.name
  environment = var.environment
  dns_prefix = var.dns_prefix
  plan_tier = var.plan_tier
  storage_replication = var.storage_replication
  resource_group_name = module.rg.resource_group_name
  resource_group_location = module.rg.resource_group_location
}