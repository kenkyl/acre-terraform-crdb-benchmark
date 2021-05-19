# Containers for memtier output file
# require a sas storage account to write the file into the container

data "azurerm_storage_account_sas" "memtiercontainer" {
  connection_string = azurerm_storage_account.mystorageaccount.primary_connection_string
  https_only        = true
  signed_version    = "2017-07-29"

  resource_types {
    service   = true
    container = true
    object    = true
  }

  services {
    blob  = true
    queue = true
    table = true
    file  = true
  }

  start  = "2018-03-21T00:00:00Z"
  expiry = "2025-03-21T00:00:00Z"

  permissions {
    read    = true
    write   = true
    delete  = true
    list    = true
    add     = true
    create  = true
    update  = true
    process = true
  }
}