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
    ip_cidr_range              = string
    network                    = optional(string)
    description                = optional(string)
    purpose                    = optional(string)
    role                       = optional(string)
    secondary_ip_range         = optional(list(map(string)))
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

variable "firewall_rules" {
  type = map(object({
    allow = optional(list(
      object({
        protocol = string
        ports    = optional(list(string))
      })
    ))
    deny = optional(list(
      object({
        protocol = string
        ports    = optional(list(string))
      })
    ))
    description        = optional(string)
    destination_ranges = optional(list(string))
    direction          = optional(string)
    disabled           = optional(bool)
    log_config = optional(list(object({
      metadata = string
    })))
    priority                = optional(number)
    source_ranges           = optional(list(string))
    source_service_accounts = optional(list(string))
    source_tags             = optional(list(string))
    target_service_accounts = optional(list(string))
    target_tags             = optional(list(string))
    enable_logging          = optional(bool)
  }))
  description = <<_EOT
  (Optional) List of firewall rules. Each element must contain the following attributes:
  - name: Name of the firewall rule.
  - allow: (Optional) List of allow blocks. Each block must contain the following attributes:
    - protocol: The IP protocol to which this rule applies. The protocol type is required when creating a firewall rule. Possible values are: AH, ESP, GRE, ICMP, ICMPv6, IP, SCTP, TCP, UDP.
    - ports: (Optional) List of ports which are allowed by this rule. This field is only applicable for UDP or TCP protocol.
  - deny: (Optional) List of deny blocks. Each block must contain the following attributes:
    - protocol: The IP protocol to which this rule applies. The protocol type is required when creating a firewall rule. Possible values are: AH, ESP, GRE, ICMP, ICMPv6, IP, SCTP, TCP, UDP.
    - ports: (Optional) List of ports which are denied by this rule. This field is only applicable for UDP or TCP protocol.
  - description: (Optional) An optional description of this resource. The resource must be recreated to modify this field.
  - destination_ranges: (Optional) If destination ranges are specified, the firewall will apply only to traffic that has destination IP address in these ranges. These ranges must be expressed in CIDR format. Only IPv4 is supported.
  - direction: (Optional) Direction of traffic to which this firewall applies. Default is INGRESS. Possible values are: INGRESS, EGRESS.
  - disabled: (Optional) Denotes whether the firewall rule is disabled, i.e not applied to the network it is associated with. When set to true, the firewall rule is not enforced and the network behaves as if it did not exist. If not set, the firewall rule is enabled.
  - log_config: (Optional) List of log config for a firewall rule. Each element must contain the following attributes:
    - metadata: The metadata for firewall logs. Possible values are: INCLUDE_ALL_METADATA, EXCLUDE_ALL_METADATA, CUSTOM_METADATA.
  - priority: (Optional) Priority for this rule. This is an integer between 0 and 65535, both inclusive. When not specified, the value chosen is based on the direction of the rule.
  - source_ranges: (Optional) If source ranges are specified, the firewall will apply only to traffic that has source IP address in these ranges. These ranges must be expressed in CIDR format. Only IPv4 is supported.
  - source_service_accounts: (Optional) If source service accounts are specified, the firewall will apply only to traffic originating from an instance with a service account in this list. Source service accounts cannot be used to control traffic to an instance's external IP address because service accounts are associated with an instance, not an IP address.
  - source_tags: (Optional) If source tags are specified, the firewall will apply only to traffic with source IP that belongs to a tag listed in source tags. Source tags cannot be used to control traffic to an instance's external IP address because tags are associated with an instance, not an IP address.
  - target_service_accounts: (Optional) A list of service accounts indicating sets of instances located in the network that may make network connections as specified in allowed[]. target_service_accounts cannot be used to control traffic to an instance's external IP address because service accounts are associated with an instance, not an IP address.
  - target_tags: (Optional) A list of instance tags indicating sets of instances located in the network that may make network connections as specified in allowed[]. If target_tags is specified, the firewall rule applies only to traffic with target tags listed. However, if no target_tags are specified, the firewall rule applies to all instances in the network.
  - enable_logging: (Optional) This field denotes whether to enable logging for a particular firewall rule. If logging is enabled, logs will be exported to the configured export destination in Stackdriver. If not set, logging will not be enabled for this firewall rule.
  _EOT
  default     = {}
}


variable "routes" {
  type = map(object({
    dest_range             = string
    description            = optional(string)
    priority               = optional(number)
    next_hop_gateway       = optional(string)
    next_hop_instance      = optional(string)
    next_hop_ip            = optional(string)
    next_hop_vpn_tunnel    = optional(string)
    next_hop_ilb           = optional(string)
    next_hop_instance_zone = optional(string)
    tags                   = optional(list(string))
  }))
  description = <<_EOT
  (Optional) List of routes. Each element must contain the following attributes:
  - dest_range: The destination range of outgoing packets that this route applies to. Only IPv4 is supported.
  - description: (Optional) An optional description of this resource. The resource must be recreated to modify this field.
  - priority: (Optional) The priority of this route. Priority is used to break ties in cases where there is more than one matching route of equal prefix length. In the case of two routes with equal prefix length, the one with the lowest-valued priority wins.
  - next_hop_gateway: (Optional) The URL to a gateway that should handle matching packets. Currently, the only supported gateway is default-internet-gateway.
  - next_hop_instance: (Optional) The URL to an instance that should handle matching packets. The instance must be in the same region as the router that is making the request.
  - next_hop_ip: (Optional) The network IP address of an instance that should handle matching packets. Only IPv4 is supported.
  - next_hop_vpn_tunnel: (Optional) The URL to a VpnTunnel that should handle matching packets.
  - next_hop_ilb: (Optional) The URL to a forwarding rule of type loadBalancingScheme INTERNAL that should handle matching packets.
  - next_hop_instance_zone: (Optional) The zone in which the next_hop_instance is located.
  - tags: (Optional) A list of instance tags to which this route applies.
  _EOT
  default     = {}
}

variable "module_depends_on" {
  type        = list(string)
  description = "(Optional) A list of resources that this resource depends on. A dependency exists if the dependent resource will be created before the resource that has the dependency."
  default     = []
}

### Router ###
variable "create_router" {
  type        = bool
  description = "(Optional) Whether to create the router or not. Default is true."
  default     = false
}

variable "router_name" {
  type        = string
  description = "(Optional) Name of the resource. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash."
  default     = null
}

variable "route_region" {
  type        = string
  description = "(Optional) The region in which the router will be created. If it is not provided, the provider region is used."
  default     = null
}

variable "encrypted_interconnect_router" {
  type        = bool
  description = "(Optional) Indicates if a router is dedicated for use with encrypted VLAN attachments (interconnectAttachments)."
  default     = false
}

variable "bgp" {
  type = map(object({
    asn               = number
    advertise_mode    = optional(string)
    advertised_groups = optional(list(string))
    advertised_ip_ranges = optional(list(object({
      range       = string
      description = optional(string)
    })))
    keepalive_interval = optional(number)
    identifier_range   = optional(string)
  }))
  description = <<_EOT
  (Optional) BGP information. It is used to configure the BGP session between the router and the Google Cloud network. It must contain the following attributes:
  - asn: An autonomous system number (ASN) is a globally unique number that is used to identify an autonomous system (AS) that is part of the global BGP routing system.
  - advertise_mode: (Optional) The mode to use for advertisement. Valid values are DEFAULT, CUSTOM. Default is DEFAULT.
  - advertised_groups: (Optional) User-specified list of prefix groups to advertise in custom mode. This field can only be populated if advertise_mode is CUSTOM and is advertised to all peers of the router. These groups will be advertised in addition to any specified prefixes. Leave this field blank to advertise no custom groups.
  - advertised_ip_ranges: (Optional) User-specified list of individual IP ranges to advertise in custom mode. This field can only be populated if advertise_mode is CUSTOM and is advertised to all peers of the router. These IP ranges will be advertised in addition to any specified groups. Leave this field blank to advertise no custom IP ranges.
    - range: The IP range to advertise. The value must be a CIDR-formatted string.
    - description: (Optional) An optional description of this resource. The resource must be recreated to modify this field.
  - keepalive_interval: (Optional) The interval in seconds between BGP keepalive messages that are sent to the peer. The default is 60 seconds.
  - identifier_range: (Optional) The range of internal addresses that are owned by this subnetwork.
  _EOT
  default     = {}
}


### Router NAT ###
variable "create_router_nat" {
  type        = bool
  description = "(Optional) Whether to create the router NAT or not. Default is true."
  default     = false
}

variable "nat_name" {
  type        = string
  description = "(Optional) Name of the NAT service. The name must be 1-63 characters long and comply with RFC1035."
  default     = null
}

variable "source_subnetwork_ip_ranges_to_nat" {
  type        = string
  description = "(Optional) How NAT should be configured per Subnetwork. If ALL_SUBNETWORKS_ALL_IP_RANGES, all of the IP ranges in every Subnetwork are allowed to Nat. If ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, all of the primary IP ranges in every Subnetwork are allowed to Nat. LIST_OF_SUBNETWORKS: A list of Subnetworks are allowed to Nat (specified in the field subnetwork below). Note that if this field contains ALL_SUBNETWORKS_ALL_IP_RANGES or ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, then there should not be any other RouterNat section in any Router for this network in this region. Possible values are: ALL_SUBNETWORKS_ALL_IP_RANGES, ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, LIST_OF_SUBNETWORKS."
  default     = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

variable "nat_ips" {
  type        = list(string)
  description = "(Optional) Self-links of NAT IPs. Only valid if natIpAllocateOption is set to MANUAL_ONLY."
  default     = []
}

variable "drain_nat_ips" {
  type        = list(string)
  description = "(Optional) A list of URLs of the IP resources to be drained. These IPs must be valid static external IPs that have been assigned to the NAT."
  default     = []
}

variable "subnetworks" {
  type = list(object({
    name                     = string,
    source_ip_ranges_to_nat  = list(string)
    secondary_ip_range_names = list(string)
  }))

  description = <<_EOT
  (Optional) List of subnetworks. Each element must contain the following attributes:
  - name: Name of the subnetwork.
  - source_ip_ranges_to_nat: List of primary and secondary subnetwork ranges to NAT.
  - secondary_ip_range_names: List of secondary ip range names to be used in this subnetwork.
  _EOT
  default     = []
}

variable "min_ports_per_vm" {
  type        = string
  description = "(Optional) Minimum number of ports allocated to a VM from this NAT. Defaults to 64 for static port allocation and 32 dynamic port allocation if not set.)"
  default     = 64
}

variable "max_ports_per_vm" {
  type        = string
  description = "(Optional) Maximum number of ports allocated to a VM from this NAT. This field can only be set when enableDynamicPortAllocation is enabled."
  default     = null
}

variable "enable_dynamic_port_allocation" {
  type        = bool
  description = "(Optional) Enable Dynamic Port Allocation. If minPortsPerVm is set, minPortsPerVm must be set to a power of two greater than or equal to 32. If minPortsPerVm is not set, a minimum of 32 ports will be allocated to a VM from this NAT config. If maxPortsPerVm is set, maxPortsPerVm must be set to a power of two greater than minPortsPerVm. If maxPortsPerVm is not set, a maximum of 65536 ports will be allocated to a VM from this NAT config. Mutually exclusive with enableEndpointIndependentMapping."
  default     = false
}


variable "udp_idle_timeout_sec" {
  type        = string
  description = " (Optional) Timeout (in seconds) for UDP connections. Defaults to 30s if not set."
  default     = "30"
}

variable "icmp_idle_timeout_sec" {
  type        = string
  description = "(Optional) Timeout (in seconds) for ICMP connections. Defaults to 30s if not set."
  default     = "30"
}

variable "tcp_established_idle_timeout_sec" {
  type        = string
  description = "(Optional) Timeout (in seconds) for TCP established connections. Defaults to 1200s if not set."
  default     = "120"
}

variable "tcp_transitory_idle_timeout_sec" {
  type        = string
  description = "(Optional) Timeout (in seconds) for TCP transitory connections. Defaults to 30s if not set."
  default     = "30"
}

variable "tcp_time_wait_timeout_sec" {
  type        = string
  description = "(Optional) Timeout (in seconds) for TCP connections that are in TIME_WAIT state. Defaults to 120s if not set."
  default     = "120"
}

variable "log_config_enable" {
  type        = bool
  description = "(Optional) Enable logging for this NAT. Defaults to false."
  default     = false
}

variable "log_config_filter" {
  type        = string
  description = "(Optional) Specifies the desired filtering of logs on this NAT. Valid values are: \"ERRORS_ONLY\", \"TRANSLATIONS_ONLY\", \"ALL\""
  default     = "ALL"
}

variable "endpoint_types" {
  type        = string
  description = "(Optional) Specifies the endpoint Types supported by the NAT Gateway. Supported values include: ENDPOINT_TYPE_VM, ENDPOINT_TYPE_SWG, ENDPOINT_TYPE_MANAGED_PROXY_LB."
  default     = null
}

variable "rules" {
  type = list(object({
    rule_number = number
    description = optional(string)
    match       = string
    action = optional(list(object({
      source_nat_active_ips    = optional(string)
      source_nat_drain_ips     = optional(string)
      source_nat_active_ranges = optional(string)
      source_nat_drain_ranges  = optional(string)
    })))
  }))
  description = <<_EOT
  (Optional) List of rules. Each element must contain the following attributes:
  - rule_number: The rule number of the rule. It must be unique within the list of rules.
  - description: (Optional) An optional description of this resource. The resource must be recreated to modify this field.
  - match: The match criteria for the rule. Possible values are: SRC_IPS, SRC_SERVICE_ACCOUNTS, SRC_TAGS.
  - action: (Optional) The action to take when the rule is matched. Each element must contain the following attributes:
    - source_nat_active_ips: (Optional) The list of IPs to be used for NAT.
    - source_nat_drain_ips: (Optional) The list of IPs to be drained.
    - source_nat_active_ranges: (Optional) The list of ranges to be used for NAT.
    - source_nat_drain_ranges: (Optional) The list of ranges to be drained.
  _EOT
  default     = []
}

variable "enable_endpoint_independent_mapping" {
  type        = bool
  description = "(Optional) Enable endpoint independent mapping. Defaults to false. Mutually exclusive with enableDynamicPortAllocation."
  default     = false
}

