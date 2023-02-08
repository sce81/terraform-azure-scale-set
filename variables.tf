variable "name" {}
variable "sku" {}
variable "instance_count" { default = 3 }
variable "username" {}
variable "environment" {}
variable "storage_account_type" { default = "Standard_LRS" }
variable "caching" { default = "ReadWrite" }
variable "subnet_id" {}
variable "resource_group" {}
variable "user_data" {}

variable "extra_tags" {
  type    = map(any)
  default = {}
}

variable "lb_pool" {
  type    = list(string)
  default = []
}


variable "zone_balance" { default = true }
variable "image_id" {}
variable "instance_repair" { default = false }

variable "public_key" {}
variable "key_username" {}

variable "kv_access_policy" {
  description = "map of routing configuration "
  type = list(object({
    keyvault_id           = optional(string)
    object_id             = optional(list(string))
    kv_key_permissions    = optional(list(string))
    kv_secret_permissions = optional(list(string))
  }))
  default = [null]
}


variable "route_info" {
  description = "map of routing configuration "
  type = list(object({
    route_cidr     = string
    name           = string
    access         = string
    direction      = string
    source_address = optional(string)
    source_port    = string
    dest_address   = optional(string)
    dest_port      = string
    protocol       = string
    source_app_sg  = optional(list(string))
    dest_app_sg    = optional(list(string))
  }))
  default = [null]
}

variable "allow_actions" {
  type = list(any)
  default = [
    "Microsoft.Authorization/*/read",
    "Microsoft.Insights/alertRules/*",
    "Microsoft.Insights/components/*",
    "Microsoft.ResourceHealth/availabilityStatuses/read",
    "Microsoft.Resources/subscriptions/resourceGroups/read"
  ]
}
variable "deny_actions" {
  type    = list(any)
  default = []
}