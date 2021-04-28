resource "azurerm_resource_group" "resource_group" {
  name     = format("kylek%s", random_string.resource_group_name.result)
  location = random_shuffle.kylek.result[0]
  tags     = merge(var.tags, { owner = data.azuread_service_principal.kylek.display_name })
}