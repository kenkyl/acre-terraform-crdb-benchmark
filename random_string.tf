resource "random_string" "resource_group_name" {
  length  = 4
  number  = false
  special = false
  upper   = false
}


resource "random_string" "acre_name_1" {
  length  = 4
  number  = false
  special = false
  upper   = false
}

resource "random_string" "acre_name_2" {
  length  = 4
  number  = false
  special = false
  upper   = false
}

resource "random_string" "acre_group_name" {
  length  = 8
  number  = false
  special = false
  upper   = false
}

resource "random_string" "client_vm_name" {
  length  = 4
  number  = true
  special = false
  upper   = false
}

resource "random_string" "key_vault_name" {
  length  = 8
  number  = false
  special = false
  upper   = false
}

resource "random_string" "secret_name" {
  length  = 8
  number  = false
  special = false
  upper   = false
}