variable "azure_subscription_id" {
    description = "enter your azure subscritption id"
}

variable "tenant_id_id" {
    description = "enter your azure tenant id"
}

variable "location" {
    description = "enter resource group location"
    default = "EastUS"
}

variable "cluster_name" {
  description = "enter K8s cluster name"
}