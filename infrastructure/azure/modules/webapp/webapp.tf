resource "azurerm_app_service_plan" "default" {
  name                = "${var.name}-plan"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  kind                = "Windows"

  sku {
    tier = var.plan_tier
    size = var.plan_sku
  }
}

resource "azurerm_app_service" "default" {
  name                = "${var.dns_prefix}-${var.name}-aspnet-${var.environment}-app"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.default.id

  site_config {
    always_on                = true
    dotnet_framework_version = "v4.0"
  }
}