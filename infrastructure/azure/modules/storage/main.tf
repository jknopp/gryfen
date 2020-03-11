
resource "azurerm_storage_account" "default" {
  name                      = "${var.dns_prefix}${var.environment}"
  resource_group_name       = var.resource_group_name
  location                  = var.resource_group_location
  account_kind              = "StorageV2"
  account_tier              = var.plan_tier
  account_replication_type  = var.storage_replication
  enable_https_traffic_only = true
}

resource "azurerm_storage_container" "default" {
  name                  = var.name
  storage_account_name  = azurerm_storage_account.default.name
  container_access_type = "private"
}