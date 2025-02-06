terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 4.0"

    }
  }
}

provider "azurerm" {
    features {}
    subscription_id = ""
    tenant_id = ""
  
}

resource "azurerm_resource_group" "rg" {
    name = "aks-rg"
    location = var.location
}

resource "azurerm_virtual_network" "vnet" {
    name = "aks-vnet"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "aks_subnet" {
  name = "aks-subnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_kubernetes_cluster" "aks" {
  name = var.cluster_name
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  default_node_pool {
    name = "default"
    node_count = 2
    vm_size = "Standard_B2s"
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

  identity { 
    type = "SystemAssigned" 
    }

  network_profile {
    network_plugin = "azure"
    service_cidr   = "10.10.0.0/16"
    dns_service_ip = "10.10.0.10"
  }
}

resource "azurerm_container_registry" "acr" {
  name                = "myacrregistry"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}
