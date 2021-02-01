resource "azurerm_app_service_plan" "plan" {
  name                = "${local.base_name}-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  kind             = "Linux"
  reserved         = true

  sku {
    tier = "PremiumV3"
    size = "P1v3"
  }
}

resource "azurerm_app_service" "app" {
  name                       = "${local.base_name}-app"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.plan.id

  site_config {
    always_on        = true
    linux_fx_version = "DOCKER|cwiederspan/mywordpress"
    ftps_state       = "Disabled"
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    WEBSITE_VNET_ROUTE_ALL              = 1

    WORDPRESS_DB_HOST      = azurerm_mysql_server.mysql.fqdn
    WORDPRESS_DB_USER      = "${var.db_username}@${azurerm_mysql_server.mysql.name}"
    WORDPRESS_DB_PASSWORD  = var.db_password
    WORDPRESS_CONFIG_EXTRA = "define('FS_METHOD','direct');\ndefine('MYSQL_CLIENT_FLAGS', MYSQLI_CLIENT_SSL);"
  }

  storage_account {
    name         = "wpcontent"
    type         = "AzureFiles"
    account_name = azurerm_storage_account.storage.name
    share_name   = azurerm_storage_share.wpcontent.name
    access_key   = azurerm_storage_account.storage.primary_access_key
    mount_path   = "/var/www/html/wp-content"
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "injection" {
  app_service_id = azurerm_app_service.app.id
  subnet_id      = azurerm_subnet.web.id
}