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
  upgrade_mode        = var.upgrade_mode


  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  admin_ssh_key {
    username   = var.username
    public_key = var.public_key
  }

  identity {
    type = "SystemAssigned"
  }
//  identity {
//    type         = "UserAssigned"
//    identity_ids = [azurerm_user_assigned_identity.main.id]
//  }

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
     load_balancer_backend_address_pool_ids = var.lb_pool
    }
  }
  //automatic_instance_repair {
  //  enabled = var.instance_repair
  //}


  tags = merge(
    local.common_tags, var.extra_tags,
  )
}

//resource "azurerm_monitor_autoscale_setting" "autoscale" {
//  name                = "${var.name}-autoscale"
//  location            = data.azurerm_resource_group.main.location
//  resource_group_name = data.azurerm_resource_group.main.name
//  target_resource_id  = azurerm_orchestrated_virtual_machine_scale_set.vmss_terraform_tutorial.id
//  enabled             = true
//  profile {
//    name = "autoscale"
//    capacity {
//      default = 5
//      minimum = 4
//      maximum = 6
//    }


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

resource "azurerm_user_assigned_identity" "main" {
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  name                = "${var.name}-scale-set-msi"
}

resource "azurerm_role_definition" "main" {
  name        = var.name
  scope       = data.azurerm_resource_group.main.id
  description = "custom app service operator"

  permissions {
    actions     = var.allow_actions
    not_actions = var.deny_actions
  }

  assignable_scopes = [
    data.azurerm_resource_group.main.id
  ]
}

resource "azurerm_role_assignment" "assignment" {
  scope                = data.azurerm_resource_group.main.id
  role_definition_name = azurerm_role_definition.main.name
  principal_id         = lookup(azurerm_linux_virtual_machine_scale_set.main.identity[0], "principal_id")
}
