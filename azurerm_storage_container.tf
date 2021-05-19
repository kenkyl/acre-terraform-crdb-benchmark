# Containers for memtier output file

resource "azurerm_storage_container" "mycontainer" {
  name                  = "benchmarkoutput"
  storage_account_name  = azurerm_storage_account.mystorageaccount.name
  container_access_type = "container"        #"private"
}