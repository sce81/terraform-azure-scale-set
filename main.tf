resource "azurerm_linux_virtual_machine_scale_set" "main" {
  name                = "${var.name}-scale-set"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  sku                 = var.sku
  instances           = var.instance_count
  admin_username      = var.username
  zone_balance        = var.zone_balance
  user_data           = base64encode(var.user_data)
  source_image_id     = var.image_id

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  admin_ssh_key {
    username   = "simon"
    public_key = var.public_key
  }

  identity {
    type = "SystemAssigned"
  }

  extension {
    name                 = "MSILinuxExtension"
    publisher            = "Microsoft.ManagedIdentity"
    type                 = "ManagedIdentityExtensionForLinux"
    type_handler_version = "1.0"
    settings             = "{\"port\": 50342}"
  }


  network_interface {
    name    = "${var.name}-nic"
    primary = true


    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = var.subnet_id
      #   network_security_group_id = var.security_group
      load_balancer_backend_address_pool_ids = var.lb_pool
    }
  }
  automatic_instance_repair {
    enabled = var.instance_repair
  }


  tags = merge(
    local.common_tags, var.extra_tags,
  )
}

resource "azurerm_application_security_group" "main" {
  name                = "${var.name}-application-sg"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  tags = merge(
    local.common_tags, var.extra_tags,
  )
}

resource "azurerm_network_security_group" "main" {
  name                = var.name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
}

resource "azurerm_network_security_rule" "main" {
  count                                      = length(var.route_info)
  name                                       = var.route_info[count.index].name
  access                                     = var.route_info[count.index].access
  direction                                  = var.route_info[count.index].direction
  source_address_prefix                      = var.route_info[count.index].source_address
  source_port_range                          = var.route_info[count.index].source_port
  destination_address_prefix                 = var.route_info[count.index].dest_address
  destination_port_range                     = var.route_info[count.index].dest_port
  network_security_group_name                = azurerm_network_security_group.main.name
  source_application_security_group_ids      = var.route_info[count.index].source_app_sg
  destination_application_security_group_ids = var.route_info[count.index].dest_app_sg
  priority                                   = 100 + count.index
  protocol                                   = var.route_info[count.index].protocol
  resource_group_name                        = data.azurerm_resource_group.main.name

}


resource "azurerm_role_definition" "main" {
  name        = var.name
  scope       = data.azurerm_resource_group.main.id
  description = "custom app service operator"

  permissions {
    actions     = var.allow_actions
    not_actions = var.deny_actions
  }

  assignable_scopes = [data.azurerm_resource_group.main.id]
}

resource "azurerm_role_assignment" "assignment" {
  scope                = data.azurerm_resource_group.main.id
  role_definition_name = var.name
  principal_id         = lookup(azurerm_linux_virtual_machine_scale_set.main.identity[0], "principal_id")
}


//resource "azurerm_key_vault_access_policy" "main" {
//  count = local.keyvault_policy
//  key_vault_id = var.keyvault_id
//  tenant_id    = data.azurerm_client_config.current.tenant_id
//  object_id    = data.azurerm_client_config.current.object_id
//
//  key_permissions = [
//    "Get",
//  ]
//
//  secret_permissions = [
//    "Get",
//  ]
//}