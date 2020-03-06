
resource "azurerm_storage_account" "default" {
  name                      = "${var.dns_prefix}${var.environment}"
  resource_group_name       = var.resource_group_name
  location                  = var.resource_group_location
  account_kind              = "StorageV2"
  account_tier              = var.plan_tier
  account_replication_type  = var.storage_replication
  enable_https_traffic_only = true
}

# Until the TF team can fix the issue with prevent_destroy, we cannont manage the 'state' container in TF
# TF destroy will attempt to update the state when it completes and will error.
# https://github.com/hashicorp/terraform/issues/3874
# https://github.com/hashicorp/terraform/issues/23547
# resource "azurerm_storage_container" "terraform" {
#   name                  = var.terraform_backend_state_container_name
#   storage_account_name  = azurerm_storage_account.default.name
#   container_access_type = "private"
# }

resource "azurerm_storage_container" "default" {
  name                  = var.name
  storage_account_name  = azurerm_storage_account.default.name
  container_access_type = "private"
}