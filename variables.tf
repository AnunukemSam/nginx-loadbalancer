variable "location" {
  description = "The Azure region to deploy resources in"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "vm_admin_username" {
  description = "The admin username for the virtual machine(s)"
  type        = string
}

variable "public_ssh_key_path" {
  description = "Path to the public SSH key for VM authentication"
  type        = string
}

variable "vm_count" {
  description = "Number of virtual machines to create"
  type        = number
  default     = 3
}