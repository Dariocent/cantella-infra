terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.0"
    }
  }	

}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "existing" {
    location = "westeurope"
    name     = "DCA-RG"
    tags     = {
        "Owner" = "Dario CANTELLA"
    }
}

# Azure Container Registry
resource "azurerm_container_registry" "cantelladevregistry" {
  name                = "cantelladevregistry"
  resource_group_name = azurerm_resource_group.existing.name
  location            = azurerm_resource_group.existing.location
  sku                 = "Standard"
  admin_enabled       = true
  public_network_access_enabled = true
  anonymous_pull_enabled = true
  tags                = {}
}

resource "azurerm_storage_account" "terraformstateaccount" {
  name                     = "terraformstateeaccount"
  resource_group_name      = azurerm_resource_group.existing.name
  location                 = azurerm_resource_group.existing.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_storage_container" "terraformstatecontainer" {
  name                  = "terraformstatecontainer"
  storage_account_name  = azurerm_storage_account.terraformstateaccount.name
  container_access_type = "private"
}

resource "azurerm_kubernetes_cluster" "akscluster" {
  name                = "aks-cluster"
  location            = azurerm_resource_group.existing.location
  resource_group_name = azurerm_resource_group.existing.name
  dns_prefix          = "aks-cluster"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Development"
  }
}
