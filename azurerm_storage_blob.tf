



resource "azurerm_storage_container" "mycontainer" {
  name                  = "content"
  storage_account_name  = azurerm_storage_account.mystorageaccount.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "myblob" {
  name                   = "memtier_outfile.json"
  storage_account_name   = azurerm_storage_account.mystorageaccount.name
  storage_container_name = azurerm_storage_container.mycontainer.name
  type                   = "Block"
  # source                 = "memtier_outfile.json"
}
