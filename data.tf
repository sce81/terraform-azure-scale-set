data "azurerm_resource_group" "main" {
  name = var.resource_group
}

locals {
  common_tags = tomap({
    Environment = var.environment
    Terraform   = "true"
  })
}