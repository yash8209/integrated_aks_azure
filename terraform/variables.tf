variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  default = "int-azure-aks"
  description = "Azure Resource Group name"
  type        = string
}

variable "acr_name" {
  default = "yashpacr11"
  description = "Azure Container Registry name (lowercase, unique)"
  type        = string
}

variable "aks_name" {
  default = "yashpaks11"
  description = "AKS Cluster name"
  type        = string
}

variable "aks_dns_prefix" {
  default = "ypaks"
  description = "DNS prefix for AKS"
  type        = string
}

variable "node_count" {
  description = "Number of AKS nodes"
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "AKS node size"
  type        = string
  default     = "Standard_B2s"
}

