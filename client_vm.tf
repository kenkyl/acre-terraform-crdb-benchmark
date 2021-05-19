# Configure the Microsoft Azure Provider

# Create a resource group if it doesn't exist

# Create virtual network
resource "azurerm_virtual_network" "myterraformnetwork" {
  name                = "myVnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.client_region
  resource_group_name = azurerm_resource_group.resource_group.name

  tags = {
    environment = "Terraform Demo"
  }
}

# Create subnet
resource "azurerm_subnet" "myterraformsubnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "myterraformpublicip" {
  name                = "myPublicIP"
  location            = var.client_region
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "Terraform Demo"
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformnsg" {
  name                = "myNetworkSecurityGroup"
  location            = var.client_region
  resource_group_name = azurerm_resource_group.resource_group.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Terraform Demo"
  }
}

# Create network interface
resource "azurerm_network_interface" "myterraformnic" {
  name                = "myNIC"
  location            = var.client_region
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
  }

  tags = {
    environment = "Terraform Demo"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.myterraformnic.id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.resource_group.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = var.client_region
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true    # allow public access?

  tags = {
    environment = "Terraform Demo"
  }
}

# Create (and display) an SSH key
## TODO: export private key, in the mean time you can grab the key from terraform.tfstate instances private_key_pem
## copy the key, put it in a .pem file, find and replace the \n with enter. 
## Then open a cli, chmod 400 the pem key, then use it to access the instance
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
output "tls_private_key" {
  sensitive = true
  value     = tls_private_key.example_ssh.private_key_pem
}

# Define data block for memtier 
data "template_file" "script" {
  template = file("${path.module}/install_memtier_benchmark.yml")

  vars = {
    memtier_data_input_1 = var.memtier_data_input_1
    memtier_benchmark_1  = var.memtier_benchmark_1
    outfile_name_1 = var.outfile_name_1
    txt_outfile_name_1 = var.txt_outfile_name_1
    memtier_benchmark_2  = var.memtier_benchmark_2
    outfile_name_2 = var.outfile_name_2
    txt_outfile_name_2 = var.txt_outfile_name_2
    ## You cannot extract attributes from an ARM template, so the acre hostname must be built from other vars.
    test_acre_url_1 = format("acre-aa-benchmark%s.%s.redisenterprise.cache.azure.net", random_string.acre_name_1.result, random_shuffle.acre-aa-benchmark.result[0])
    acre_port_1     = "10000"
    access_key = data.azurerm_key_vault_secret.acre_1.value
    containersasurl = format("https://%s.blob.core.windows.net/benchmarkoutput/%s", azurerm_storage_account.mystorageaccount.name, data.azurerm_storage_account_sas.memtiercontainer.sas)
  }
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content      = data.template_file.script.rendered
  }
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "memtier_vm" {
  name                  = format("%s-%s", var.client_vm_name_root, random_string.client_vm_name.result)
  location              = var.client_region
  resource_group_name   = azurerm_resource_group.resource_group.name
  network_interface_ids = [azurerm_network_interface.myterraformnic.id]
  size                  = "Standard_DS1_v2"
  custom_data           = data.template_cloudinit_config.config.rendered

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }
  
  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "Terraform Demo"
  }

  depends_on = [azurerm_resource_group_template_deployment.acre_2]

}