data "azuread_service_principal" "kylek" {
  application_id = var.client_id
}
