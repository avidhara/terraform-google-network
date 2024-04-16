variable "create" {
  type        = bool
  description = "(optional) Whether to create the network or not. Default is true."
  default     = true
}

variable "name" {
  type        = string
  description = "(Required) Name of the resource. Provided by the client when the resource is created. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash."

}

variable "description" {
  type        = string
  description = "(Optional) An optional description of this resource. The resource must be recreated to modify this field."
  default     = null
}

variable "project" {
  type        = string
  description = "(Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  default     = null
}

variable "auto_create_subnetworks" {
  type        = bool
  description = "(Optional) When set to true, the network is created in \"auto subnet mode\" and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in \"custom subnet mode\" so the user can explicitly connect subnetwork resources."
  default     = false
}

variable "routing_mode" {
  type        = string
  description = "(Optional) The network-wide routing mode to use. If set to REGIONAL, this network's cloud routers will only advertise routes with subnetworks of this network in the same region as the router. If set to GLOBAL, this network's cloud routers will advertise routes with all subnetworks of this network, across regions. Possible values are: REGIONAL, GLOBAL."
  default     = "GLOBAL"
}

variable "mtu" {
  type        = number
  description = "(Optional) Maximum Transmission Unit in bytes. The default value is 1460 bytes. The minimum value for this field is 1300 and the maximum value is 8896 bytes (jumbo frames). Note that packets larger than 1500 bytes (standard Ethernet) can be subject to TCP-MSS clamping or dropped with an ICMP Fragmentation-Needed message if the packets are routed to the Internet or other VPCs with varying MTUs."
  default     = null
}

variable "enable_ula_internal_ipv6" {
  type        = bool
  description = "(Optional) Enable ULA internal ipv6 on this network. Enabling this feature will assign a /48 from google defined ULA prefix fd20::/20."
  default     = false
}

variable "internal_ipv6_range" {
  type        = string
  description = "(Optional) When enabling ula internal ipv6, caller optionally can specify the /48 range they want from the google defined ULA prefix fd20::/20. The input must be a valid /48 ULA IPv6 address and must be within the fd20::/20. Operation will fail if the speficied /48 is already in used by another resource. If the field is not speficied, then a /48 range will be randomly allocated from fd20::/20 and returned via this field."
  default     = null
}

variable "network_firewall_policy_enforcement_order" {
  type        = string
  description = "(Optional) Set the order that Firewall Rules and Firewall Policies are evaluated. Default value is AFTER_CLASSIC_FIREWALL. Possible values are: BEFORE_CLASSIC_FIREWALL, AFTER_CLASSIC_FIREWALL."
  default     = null
}

variable "delete_default_routes_on_create" {
  type        = bool
  description = "(Optional) If set to true, default routes (0.0.0.0/0) will be deleted immediately after network creation. Defaults to false."
  default     = true
}
