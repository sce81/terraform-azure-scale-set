# terraform-azure-scale-set
### All code is provided for reference purposes only and is used entirely at own risk. Code is for use in development environments only. Not suitable for Production.


Terraform module for creating an Azure Linux Scale Set


## Usage

    module "example" {
      source         = "git@github.com:sce81/terraform-azure-scale-set.git"
      name           = var.name
      environment    = var.environment
      sku            = var.username
      instance_count = var.instance_count
      username       = var.username
      resource_group = var.resource_group
      subnet_id      = data.azurerm_subnet.main.id
      image_id       = data.azurerm_image.main.id
      public_key     = var.public_key
      key_username   = "ubuntu"
      user_data      = local.vault_userdata
      route_info     = local.route_info
      lb_pool        = module.vault_lb.lb_pool
    }


### Prerequisites

Terraform >= 1.15.7
### Tested

Terraform >= 1.15.7
### Outputs

    app_sg_id:      = azurerm_application_security_group.main.id
    id:             = azurerm_linux_virtual_machine_scale_set.main.id
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.15.7 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_application_security_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_security_group) | resource |
| [azurerm_linux_virtual_machine_scale_set.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) | resource |
| [azurerm_network_security_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_user_assigned_identity.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_allow_actions"></a> [allow\_actions](#input\_allow\_actions) | n/a | `list(any)` | <pre>[<br/>  "Microsoft.Authorization/*/read",<br/>  "Microsoft.Insights/alertRules/*",<br/>  "Microsoft.Insights/components/*",<br/>  "Microsoft.ResourceHealth/availabilityStatuses/read",<br/>  "Microsoft.Resources/subscriptions/resourceGroups/read",<br/>  "Microsoft.Network/networkInterfaces/*",<br/>  "Microsoft.Compute/virtualMachineScaleSets/*/read"<br/>]</pre> | no |
| <a name="input_caching"></a> [caching](#input\_caching) | n/a | `string` | `"ReadWrite"` | no |
| <a name="input_deny_actions"></a> [deny\_actions](#input\_deny\_actions) | n/a | `list(any)` | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `any` | n/a | yes |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | n/a | `map(any)` | `{}` | no |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | n/a | `any` | n/a | yes |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | n/a | `number` | `3` | no |
| <a name="input_instance_repair"></a> [instance\_repair](#input\_instance\_repair) | n/a | `bool` | `false` | no |
| <a name="input_kv_access_policy"></a> [kv\_access\_policy](#input\_kv\_access\_policy) | map of routing configuration | <pre>list(object({<br/>    keyvault_id           = optional(string)<br/>    object_id             = optional(list(string))<br/>    kv_key_permissions    = optional(list(string))<br/>    kv_secret_permissions = optional(list(string))<br/>  }))</pre> | <pre>[<br/>  null<br/>]</pre> | no |
| <a name="input_lb_pool"></a> [lb\_pool](#input\_lb\_pool) | n/a | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `any` | n/a | yes |
| <a name="input_public_key"></a> [public\_key](#input\_public\_key) | n/a | `any` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | n/a | `any` | n/a | yes |
| <a name="input_route_info"></a> [route\_info](#input\_route\_info) | map of routing configuration | <pre>list(object({<br/>    // route_cidr     = string<br/>    name           = string<br/>    access         = string<br/>    direction      = string<br/>    source_address = optional(string)<br/>    source_port    = string<br/>    dest_address   = optional(string)<br/>    dest_port      = string<br/>    protocol       = string<br/>    source_app_sg  = optional(list(string))<br/>    dest_app_sg    = optional(list(string))<br/>  }))</pre> | <pre>[<br/>  null<br/>]</pre> | no |
| <a name="input_sku"></a> [sku](#input\_sku) | n/a | `any` | n/a | yes |
| <a name="input_storage_account_type"></a> [storage\_account\_type](#input\_storage\_account\_type) | n/a | `string` | `"Standard_LRS"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | n/a | `any` | n/a | yes |
| <a name="input_upgrade_mode"></a> [upgrade\_mode](#input\_upgrade\_mode) | n/a | `string` | `"Manual"` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | n/a | `any` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | n/a | `any` | n/a | yes |
| <a name="input_zone_balance"></a> [zone\_balance](#input\_zone\_balance) | n/a | `bool` | `true` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_app_sg_id"></a> [app\_sg\_id](#output\_app\_sg\_id) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_identity"></a> [identity](#output\_identity) | n/a |
| <a name="output_identity2"></a> [identity2](#output\_identity2) | n/a |
<!-- END_TF_DOCS -->
