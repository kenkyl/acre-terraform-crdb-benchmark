

locals {
  acre-aa-benchmark_config = {
    acre_1 = azurerm_resource_group_template_deployment.acre_1.*
    #acre_2              = azurerm_resource_group_template_deployment.acre_2.*
    resource_group_name = azurerm_resource_group.resource_group.name
  }
  secrets = {
    keyVaultName = random_string.key_vault_name.result
    secretName   = random_string.secret_name.result
  }
}

output "secrets" {
  value     = local.secrets
  sensitive = false
}

output "acre-aa-benchmark_config" {
  value     = jsonencode(local.acre-aa-benchmark_config)
  sensitive = false
}

########################################################################### EDITS

locals {
  host    = azurerm_linux_virtual_machine.memtier_vm.public_ip_address
  user    = "azureuser"
  program = "/usr/local/bin/memtier_benchmark"
}

output "host" {
  value       = local.host
  description = "Public IP for memtier instance"
}

output "user" {
  value       = local.user
  description = "user with access to host"
}

output "program" {
  value       = local.program
  description = "Absolute path to program on host"
}

output "run_memtier" {
  value       = "ssh -i ~/.ssh/YOURKEYNAME.pem ${local.user}@${local.host} ${local.program}"
  description = "ssh string to execute memtier_benchmark on target Azure vm instance"
}


####### BLOB

locals {
  blob_url = azurerm_storage_blob.myblob.url
  blob_id       = azurerm_storage_blob.myblob.id
}

output "blob_url" {
  value       = local.blob_url
  description = "blob url"
}

output "blob_id" {
  value       = local.blob_id
  description = "blob id"
}