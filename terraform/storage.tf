resource "azurerm_storage_account" "storage" {
  name                     = replace(local.base_name, "-", "")
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "wpcontent" {
  name                 = "wpcontent"
  storage_account_name = azurerm_storage_account.storage.name
  quota                = 50
}