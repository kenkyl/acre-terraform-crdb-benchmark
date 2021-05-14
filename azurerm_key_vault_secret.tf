data "azurerm_key_vault_secret" "acre_1" {
  name         = random_string.secret_name.result
  key_vault_id = data.azurerm_key_vault.acre.id
}