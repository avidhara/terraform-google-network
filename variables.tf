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

#### Subnets ####

variable "subnets" {
  type = map(object({
    name                       = string
    ip_cidr_range              = string
    network                    = optional(string)
    description                = optional(string)
    purpose                    = optional(string)
    role                       = optional(string)
    secondary_ip_range         = list(map(string))
    private_ipv6_google_access = optional(string)
    private_ip_google_access   = optional(bool)
    region                     = string
    log_config = optional(list(object({
      aggregation_interval = optional(string)
      flow_sampling        = optional(string)
      metadata             = optional(string)
      metadata_fields      = optional(list(string))
      filter_expr          = optional(string)
    })))
    stack_type                       = optional(string)
    ipv6_access_type                 = optional(string)
    external_ipv6_prefix             = optional(string)
    allow_subnet_cidr_routes_overlap = optional(bool)
  }))
  description = <<_EOT
  (Optional) List of subnetworks. Each element must contain the following attributes:
  - name: Name of the subnetwork.
  - ip_cidr_range: The range of internal addresses that are owned by this subnetwork.
  - network: The network this subnet belongs to. If not provided, the network will be created in auto subnet mode.
  - description: (Optional) An optional description of this resource. The resource must be recreated to modify this field.
  - purpose: (Optional) The purpose of the resource. Possible values are: INTERNAL_HTTPS_LOAD_BALANCER, INTERNAL_TCP_UDP_LOAD_BALANCER, PRIVATE, PUBLIC.
  - role: (Optional) The role of subnetwork. Possible values are: ACTIVE, INACTIVE.
  - secondary_ip_range: (Optional) List of secondary ip ranges to be used in this subnetwork.
  - private_ipv6_google_access: (Optional) The private ipv6 google access type. Possible values are: OFF, ON.
  - private_ip_google_access: (Optional) The private ip google access type. Default is false.
  - region: The region this subnetwork belongs to.
  - log_config: (Optional) List of log config for a subnetwork. Each element must contain the following attributes:
    - aggregation_interval: (Optional) The aggregation interval for flow logs. Default is 5 seconds.
    - flow_sampling: (Optional) The flow sampling for flow logs. Default is 0.5.
    - metadata: (Optional) The metadata for flow logs. Possible values are: INCLUDE_ALL_METADATA, EXCLUDE_ALL_METADATA, CUSTOM_METADATA.
    - metadata_fields: (Optional) The metadata fields for flow logs. Required if metadata is CUSTOM_METADATA.
    - filter_expr: (Optional) The filter expression for flow logs.
  - stack_type: (Optional) The stack type of the subnetwork. Possible values are: IPV4_ONLY, IPV4_IPV6.
  - ipv6_access_type: (Optional) The ipv6 access type of the subnetwork. Possible values are: OFF, ON.
  - external_ipv6_prefix: (Optional) The external ipv6 prefix of the subnetwork.
  - allow_subnet_cidr_routes_overlap: (Optional) Whether to allow subnet cidr routes overlap. Default is false.
  _EOT
  default     = {}
}
