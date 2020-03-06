# Until the TF team can fix the issue with prevent_destroy, we cannont manage the 'state' container in TF
# TF destroy will attempt to update the state when it completes and will error.
# https://github.com/hashicorp/terraform/issues/3874
# https://github.com/hashicorp/terraform/issues/23547
resource "azurerm_storage_container" "terraform" {
  name                  = var.terraform_backend_state_container_name
  storage_account_name  = var.storage_account_name
  container_access_type = "private"
}