# Terraform module for Google Cloud Network

## Usage
```hcl
module "vpc" {
  source = "./"
  name = "terraform-vpc"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.2 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5, < 6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 5, < 6 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_network.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_subnetwork.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_create_subnetworks"></a> [auto\_create\_subnetworks](#input\_auto\_create\_subnetworks) | (Optional) When set to true, the network is created in "auto subnet mode" and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in "custom subnet mode" so the user can explicitly connect subnetwork resources. | `bool` | `false` | no |
| <a name="input_create"></a> [create](#input\_create) | (optional) Whether to create the network or not. Default is true. | `bool` | `true` | no |
| <a name="input_delete_default_routes_on_create"></a> [delete\_default\_routes\_on\_create](#input\_delete\_default\_routes\_on\_create) | (Optional) If set to true, default routes (0.0.0.0/0) will be deleted immediately after network creation. Defaults to false. | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) An optional description of this resource. The resource must be recreated to modify this field. | `string` | `null` | no |
| <a name="input_enable_ula_internal_ipv6"></a> [enable\_ula\_internal\_ipv6](#input\_enable\_ula\_internal\_ipv6) | (Optional) Enable ULA internal ipv6 on this network. Enabling this feature will assign a /48 from google defined ULA prefix fd20::/20. | `bool` | `false` | no |
| <a name="input_internal_ipv6_range"></a> [internal\_ipv6\_range](#input\_internal\_ipv6\_range) | (Optional) When enabling ula internal ipv6, caller optionally can specify the /48 range they want from the google defined ULA prefix fd20::/20. The input must be a valid /48 ULA IPv6 address and must be within the fd20::/20. Operation will fail if the speficied /48 is already in used by another resource. If the field is not speficied, then a /48 range will be randomly allocated from fd20::/20 and returned via this field. | `string` | `null` | no |
| <a name="input_mtu"></a> [mtu](#input\_mtu) | (Optional) Maximum Transmission Unit in bytes. The default value is 1460 bytes. The minimum value for this field is 1300 and the maximum value is 8896 bytes (jumbo frames). Note that packets larger than 1500 bytes (standard Ethernet) can be subject to TCP-MSS clamping or dropped with an ICMP Fragmentation-Needed message if the packets are routed to the Internet or other VPCs with varying MTUs. | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of the resource. Provided by the client when the resource is created. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash. | `string` | n/a | yes |
| <a name="input_network_firewall_policy_enforcement_order"></a> [network\_firewall\_policy\_enforcement\_order](#input\_network\_firewall\_policy\_enforcement\_order) | (Optional) Set the order that Firewall Rules and Firewall Policies are evaluated. Default value is AFTER\_CLASSIC\_FIREWALL. Possible values are: BEFORE\_CLASSIC\_FIREWALL, AFTER\_CLASSIC\_FIREWALL. | `string` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | (Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used. | `string` | `null` | no |
| <a name="input_routing_mode"></a> [routing\_mode](#input\_routing\_mode) | (Optional) The network-wide routing mode to use. If set to REGIONAL, this network's cloud routers will only advertise routes with subnetworks of this network in the same region as the router. If set to GLOBAL, this network's cloud routers will advertise routes with all subnetworks of this network, across regions. Possible values are: REGIONAL, GLOBAL. | `string` | `"GLOBAL"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | (Optional) List of subnetworks. Each element must contain the following attributes:<br>  - name: Name of the subnetwork.<br>  - ip\_cidr\_range: The range of internal addresses that are owned by this subnetwork.<br>  - network: The network this subnet belongs to. If not provided, the network will be created in auto subnet mode.<br>  - description: (Optional) An optional description of this resource. The resource must be recreated to modify this field.<br>  - purpose: (Optional) The purpose of the resource. Possible values are: INTERNAL\_HTTPS\_LOAD\_BALANCER, INTERNAL\_TCP\_UDP\_LOAD\_BALANCER, PRIVATE, PUBLIC.<br>  - role: (Optional) The role of subnetwork. Possible values are: ACTIVE, INACTIVE.<br>  - secondary\_ip\_range: (Optional) List of secondary ip ranges to be used in this subnetwork.<br>  - private\_ipv6\_google\_access: (Optional) The private ipv6 google access type. Possible values are: OFF, ON.<br>  - private\_ip\_google\_access: (Optional) The private ip google access type. Default is false.<br>  - region: The region this subnetwork belongs to.<br>  - log\_config: (Optional) List of log config for a subnetwork. Each element must contain the following attributes:<br>    - aggregation\_interval: (Optional) The aggregation interval for flow logs. Default is 5 seconds.<br>    - flow\_sampling: (Optional) The flow sampling for flow logs. Default is 0.5.<br>    - metadata: (Optional) The metadata for flow logs. Possible values are: INCLUDE\_ALL\_METADATA, EXCLUDE\_ALL\_METADATA, CUSTOM\_METADATA.<br>    - metadata\_fields: (Optional) The metadata fields for flow logs. Required if metadata is CUSTOM\_METADATA.<br>    - filter\_expr: (Optional) The filter expression for flow logs.<br>  - stack\_type: (Optional) The stack type of the subnetwork. Possible values are: IPV4\_ONLY, IPV4\_IPV6.<br>  - ipv6\_access\_type: (Optional) The ipv6 access type of the subnetwork. Possible values are: OFF, ON.<br>  - external\_ipv6\_prefix: (Optional) The external ipv6 prefix of the subnetwork.<br>  - allow\_subnet\_cidr\_routes\_overlap: (Optional) Whether to allow subnet cidr routes overlap. Default is false. | <pre>map(object({<br>    name                       = string<br>    ip_cidr_range              = string<br>    network                    = optional(string)<br>    description                = optional(string)<br>    purpose                    = optional(string)<br>    role                       = optional(string)<br>    secondary_ip_range         = list(map(string))<br>    private_ipv6_google_access = optional(string)<br>    private_ip_google_access   = optional(bool)<br>    region                     = string<br>    log_config = optional(list(object({<br>      aggregation_interval = optional(string)<br>      flow_sampling        = optional(string)<br>      metadata             = optional(string)<br>      metadata_fields      = optional(list(string))<br>      filter_expr          = optional(string)<br>    })))<br>    stack_type                       = optional(string)<br>    ipv6_access_type                 = optional(string)<br>    external_ipv6_prefix             = optional(string)<br>    allow_subnet_cidr_routes_overlap = optional(bool)<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gateway_ipv4"></a> [gateway\_ipv4](#output\_gateway\_ipv4) | The gateway address for default routing out of the network. This value is selected by GCP. |
| <a name="output_id"></a> [id](#output\_id) | an identifier for the resource with format projects/{{project}}/global/networks/{{name}} |
| <a name="output_numeric_id"></a> [numeric\_id](#output\_numeric\_id) | The unique identifier for the resource. This identifier is defined by the server. |
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | The URI of the created resource. |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->