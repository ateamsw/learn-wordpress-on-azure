/*
resource "azurerm_storage_account" "storage" {
  name                     = replace(local.base_name, "-", "")
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
*/

resource "azurerm_storage_account" "storage" {
  name                     = replace(local.base_name, "-", "")
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_kind             = "FileStorage"
  account_tier             = "Premium"
  account_replication_type = "LRS"

  /*
  network_rules {
    default_action             = "Deny"
    ip_rules                   = []
    virtual_network_subnet_ids = []
    bypass                     = ["Logging", "Metrics", "AzureServices"]
  }
  */
}

resource "azurerm_storage_share" "wpcontent" {
  name                 = "wpcontent"
  storage_account_name = azurerm_storage_account.storage.name
  quota                = 100
}

resource "azurerm_private_endpoint" "fspe" {
  name                = "${local.base_name}-fspe"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.backend.id

  private_service_connection {
    name                           = "${local.base_name}-fspe"
    private_connection_resource_id = azurerm_storage_account.storage.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "${local.base_name}-fspe"
    private_dns_zone_ids = [azurerm_private_dns_zone.dnstorage.id]
  }
}