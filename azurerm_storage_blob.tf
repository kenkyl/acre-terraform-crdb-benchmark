



resource "azurerm_storage_container" "mycontainer" {
  name                  = "benchmarkoutput"
  storage_account_name  = azurerm_storage_account.mystorageaccount.name
  container_access_type = "container"        #"private"
}

resource "azurerm_storage_blob" "myblob" {
  name                   = "memtier_outfile.json"
  storage_account_name   = azurerm_storage_account.mystorageaccount.name
  storage_container_name = azurerm_storage_container.mycontainer.name
  type                   = "Block"
  # source                 = "memtier_outfile.json"
}



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

output "sas_url_query_string" {
  value = data.azurerm_storage_account_sas.memtiercontainer.sas
  sensitive = true
}

#"https://${azurerm_storage_account.mystorageaccount.name}.blob.core.windows.net/benchmark?${data.azurerm_storage_account_sas.memtiercontainer.sas}"


# data "azurerm_storage_account_blob_container_sas" "mysascontainer" {
#   connection_string = azurerm_storage_account.mystorageaccount.primary_connection_string
#   container_name    = azurerm_storage_container.mycontainer.name
#   https_only        = false  #"true"

#   #ip_address = "168.1.5.65"

#   start  = "2018-03-21"
#   expiry = "2022-03-21"

#   resource_types {

#   }

#   permissions {
#     read   = true
#     add    = true
#     create = true
#     write  = true
#     delete = true
#     list   = true
#   }

#   cache_control       = "max-age=5"
#   content_disposition = "inline"
#   content_encoding    = "deflate"
#   content_language    = "en-US"
#   content_type        = "application/json"
# }

# output "sas_url_query_string" {
#   value = data.azurerm_storage_account_blob_container_sas.mysascontainer.sas
#   sensitive = true
# }
