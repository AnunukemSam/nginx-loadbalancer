output "vm_names" {
  value = [for vm in azurerm_linux_virtual_machine.vm : vm.name]
}

output "vm_public_ips" {
  value = [for pip in azurerm_public_ip.vm : pip.ip_address]
}