data "azurerm_key_vault" "acre" {
  name                = random_string.key_vault_name.result
  resource_group_name = azurerm_resource_group.resource_group.name
  depends_on = [
    azurerm_resource_group_template_deployment.acre_1
  ]
}