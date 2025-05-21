terraform {
  required_version = "~> 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.116, < 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# tflint-ignore: terraform_module_provider_declaration, terraform_output_separate, terraform_variable_separate
provider "azurerm" {
  subscription_id                 = var.subscription_id
  resource_provider_registrations = "none"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create Virtual Network and Subnet
resource "azurerm_virtual_network" "vnet" {
  name                = "aks-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = var.vnet_cidr
}

resource "azurerm_subnet" "subnet" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_cidr
}

# Create AKS Cluster with Cilium
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  dns_prefix          = "aks"
  kubernetes_version  = "1.32.3"
  automatic_upgrade_channel = "rapid"
  tags = {
    environment = "dev"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "cilium" # Enable Cilium
    network_plugin_mode = "overlay" # Use overlay mode for Cilium
    load_balancer_sku = "standard" # Use standard SKU for load balancer
    network_data_plane = "cilium" # Use Cilium for network data plane
    pod_cidr = var.pod_cidr
    service_cidr = var.service_cidr
    dns_service_ip = var.dns_service_ip
    
    load_balancer_profile {
      managed_outbound_ip_count = 1
       
    }
  }

  default_node_pool {
    name           = var.node_pool_name
    node_count     = var.node_count
    vm_size        = var.vm_size
    auto_scaling_enabled = true
    max_count = 10
    min_count = 1
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "default" {
  name                  = "default"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size              = var.vm_size
  node_count           = var.node_count
  auto_scaling_enabled = true
  max_count = 50
  min_count = 1
  zones = [ "1", "2", "3" ] 
}