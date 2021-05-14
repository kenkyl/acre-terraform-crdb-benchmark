resource "azurerm_resource_group" "resource_group" {
  name     = format("acre-aa-benchmarks%s", random_string.resource_group_name.result)
  location = random_shuffle.acre-aa-benchmark.result[0]
  tags     = merge(var.tags, { owner = data.azuread_service_principal.acre-aa-benchmark.display_name })
}