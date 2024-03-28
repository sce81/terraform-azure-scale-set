# terraform-azure-scale-set
### All code is provided for reference purposes only and is used entirely at own risk. 

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

Terraform ~> 1.6.0  

### Tested

Terraform ~> 1.6.0  

### Outputs

app_sg_id: value = azurerm_application_security_group.main.id 
id: value        = azurerm_linux_virtual_machine_scale_set.main.id 