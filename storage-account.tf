
resource "azurerm_storage_account" "default" {
  name                      = "${var.dns_prefix}${var.environment}"
  resource_group_name       = azurerm_resource_group.default.name
  location                  = azurerm_resource_group.default.location
  account_kind              = "StorageV2"
  account_tier              = var.plan_tier
  account_replication_type  = var.storage_replication
  enable_https_traffic_only = true
}

resource "azurerm_storage_container" "terraform" {
  name                  = var.terraform_backend_state_container_name
  storage_account_name  = azurerm_storage_account.default.name
  container_access_type = "private"
}