output "app_sg_id" {
  value = azurerm_application_security_group.main.id
}

output "id" {
  value = azurerm_linux_virtual_machine_scale_set.main.id
}