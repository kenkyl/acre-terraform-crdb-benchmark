data "azuread_service_principal" "acre-aa-benchmark" {
  application_id = var.client_id
}
