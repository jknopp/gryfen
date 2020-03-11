resource "azurerm_resource_group" "infrastructure_rg" {
  name     = "infrastructure-${var.name}-${var.environment}-rg"
  location = var.location
}

resource "azurerm_storage_account" "infrastructure_storage" {
  name                      = "infra${var.environment}"
  resource_group_name       = azurerm_resource_group.infrastructure_rg.name
  location                  = azurerm_resource_group.infrastructure_rg.location
  account_kind              = "StorageV2"
  account_tier              = var.infrastructure_plan_tier
  account_replication_type  = var.infrastructure_storage_replication
  enable_https_traffic_only = true
}

# Until the TF team can fix the issue with prevent_destroy, we cannont manage the 'state' container in TF
# TF destroy will attempt to update the state when it completes and will error.
# https://github.com/hashicorp/terraform/issues/3874
# https://github.com/hashicorp/terraform/issues/23547
resource "azurerm_storage_container" "infrastructure_container" {
  name                  = var.terraform_backend_state_container_name
  storage_account_name  = azurerm_storage_account.infrastructure_storage.name
  container_access_type = "private"
}