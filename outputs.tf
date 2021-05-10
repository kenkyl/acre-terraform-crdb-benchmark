locals {
  kylek_config = {
    //acre_1              = azurerm_resource_group_template_deployment.acre_1.*
    //acre_2              = azurerm_resource_group_template_deployment.acre_2.*
    resource_group_name = azurerm_resource_group.resource_group.name
  }
}

output "kylek_config" {
  value     = jsonencode(local.kylek_config)
  sensitive = true
}

########################################################################### EDITS

locals {
    host = azurerm_linux_virtual_machine.memtier_vm.public_ip_address
    user = "azureuser"
    program = "/usr/local/bin/memtier_benchmark"
}

output "host" {
    value = local.host
    description = "Public IP for memtier instance"
}

output "user" {
    value = local.user
    description = "user with access to host"
}

output "program" {
    value = local.program
    description = "Absolute path to program on host"
}

output "run_memtier" {
    value = "ssh -i ~/.ssh/YOURKEYNAME.pem ${local.user}@${local.host} ${local.program}"
    description = "ssh string to execute memtier_benchmark on target Azure vm instance"
}