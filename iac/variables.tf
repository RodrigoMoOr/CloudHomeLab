variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
  default     = "polcentral"
}

variable "resource_group_name" {
  description = "The name of the resource group in which to deploy resources"
  type        = string
  default     = "rg-homelab"
}
