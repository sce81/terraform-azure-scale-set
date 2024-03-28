variable "name" {
  type        = string
  description = "(Required) The name of the Linux Virtual Machine Scale Set. Changing this forces a new resource to be created."
}

variable "environment" {
  type        = string
  description = "Descriptive name to identify environment for tagging purposes"
}

variable "sku" {
  type        = string
  description = "(Required) The Virtual Machine SKU for the Scale Set, such as Standard_F2"
}

variable "instance_count" {
  type        = number
  default     = 3
  description = "(Optional) The number of Virtual Machines in the Scale Set. Defaults to 0"
}

variable "username" {
  type        = string
  description = "(Required) The username of the local administrator on each Virtual Machine Scale Set instance. Changing this forces a new resource to be created."
}

variable "storage_account_type" {
  type        = string
  default     = "Standard_LRS"
  description = "(Required) The Type of Storage Account which should back this Data Disk. Possible values include Standard_LRS, StandardSSD_LRS, StandardSSD_ZRS, Premium_LRS, PremiumV2_LRS, Premium_ZRS and UltraSSD_LRS"
}

variable "caching" {
  type        = string
  default     = "ReadWrite"
  description = "(Required) The type of Caching which should be used for this Data Disk. Possible values are None, ReadOnly and ReadWrite"
}

variable "subnet_id" {
  type        = string
  description = "(Optional) The ID of the Subnet which this IP Configuration should be connected to."
}

variable "resource_group" {
  type        = string
  description = "(Required) The name of the Resource Group in which the Linux Virtual Machine Scale Set should be exist. Changing this forces a new resource to be created."
}

variable "user_data" {
  type        = string
  description = "(Optional) The Base64-Encoded User Data which should be used for this Virtual Machine Scale Set."
}

variable "extra_tags" {
  type    = map(any)
  default = {}
}

variable "lb_pool" {
  type        = list(string)
  default     = []
  description = "(Optional) A list of Backend Address Pools ID's from a Load Balancer which this Virtual Machine Scale Set should be connected to."
}

variable "zone_balance" {
  type        = bool
  default     = true
  description = "(Optional) Should the Virtual Machines in this Scale Set be strictly evenly distributed across Availability Zones? Defaults to false. Changing this forces a new resource to be created."
}

variable "image_id" {
  type        = string
  description = "(Optional) The ID of an Image which each Virtual Machine in this Scale Set should be based on. Possible Image ID types include Image ID, Shared Image ID, Shared Image Version ID, Community Gallery Image ID, Community Gallery Image Version ID, Shared Gallery Image ID and Shared Gallery Image Version ID"
}

variable "instance_repair" {
  type        = bool
  default     = false
  description = " (Optional) An automatic_instance_repair block as defined below. To enable the automatic instance repair, this Virtual Machine Scale Set must have a valid health_probe_id or an Application Health Extension."
}

variable "public_key" {
  type        = string
  description = "(Required) The Public Key which should be used for authentication, which needs to be at least 2048-bit and in ssh-rsa format."
}

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