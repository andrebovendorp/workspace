variable "subscription_id" {
  description = "value of the subscription id"
  type        = string
  sensitive   = true
}
variable "resource_group_name" {
  description = "The name of the resource group in which to create the AKS cluster."
  type        = string
  default     = "k8s-workshop"
}

variable "location" {
  description = "The Azure region where the AKS cluster will be created."
  type        = string
  default     = "swedencentral" 
}

variable "aks_cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
  default     = "k8s-workshop-developers"
}

variable "node_pool_name" {
  description = "The name of the default node pool."
  type        = string
  default     = "agentpool"
}

variable "node_count" {
  description = "The number of nodes in the node pool."
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "The size of the virtual machines in the node pool."
  type        = string
  default     = "Standard_DS2_v2"
}

variable "vnet_cidr" {
  description = "CIDR for the virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_cidr" {
  description = "CIDR for the subnet."
  type        = list(string)
  default     = ["10.0.0.0/24"]
}

variable "pod_cidr" {
  description = "The CIDR range to use for Pod IP addresses."
  type        = string
  default     = "192.168.0.0/16" #Important for Cilium
}

variable "service_cidr" {
  description = "The CIDR range to use for Service IP addresses."
  type        = string
  default     = "10.244.0.0/16"  #Important for Cilium
}

variable "dns_service_ip" {
  description = "The IP address for the DNS service."
  type        = string
  default     = "10.244.10.244"
}
