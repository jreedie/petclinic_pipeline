variable "azure_subscription_id" {
  description = "Azure Subscription ID"
}

variable "azure_client_id" {
  description = "Azure Client ID"
}

variable "azure_client_secret" {
  description = "Azure Client Secret"
}

variable "azure_tenant_id" {
  description = "Azure Tenant ID"
}

variable "azure_location" {
  description = "Azure Location, e.g. North Europe"
  default = "East US"
}

variable "resource_group_name" {
  description = "Azure Resource Group Name"
  default = "kubegroup"
}

variable "acs_engine_config_file" {
  description = "File name and location of the ACS Engine config file"
  default = "k8s.json"
}

variable "acs_engine_config_file_rendered" {
  description = "File name and location of the ACS Engine config file"
  default = "k8s_rendered.json"
}

variable "orchestrator_version" {
  description = "Version of Kubernetes to use"
  default = "1.10"
}

variable "master_vm_count" {
  description = "Number of master VMs to create"
  default = 1
}

variable "dns_prefix" {
  description = "DNS prefix for the cluster"
}

variable "vm_size" {
  description = "Azure VM type"
  default = "Standard_DS2_v2"
}

variable "worker_vm_count" {
  description = "Number of worker VMs to initially create"
  default = 1
}

variable "admin_user" {
  description = "Administrative username for the VMs"
  default = "azureuser"
}

variable "ssh_key" {
  description = "SSH public key in PEM format to apply to VMs"
}

variable "cluster_name" {
  description = "Name of the K8s cluster"
  default = "k8s-cluster"
}