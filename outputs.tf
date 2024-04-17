output "id" {
  description = "an identifier for the resource with format projects/{{project}}/global/networks/{{name}}"
  value       = try(google_compute_network.this[0].id, null)
}

output "gateway_ipv4" {
  description = "The gateway address for default routing out of the network. This value is selected by GCP."
  value       = try(google_compute_network.this[0].gateway_ipv4, null)
}

output "numeric_id" {
  description = "The unique identifier for the resource. This identifier is defined by the server."
  value       = try(google_compute_network.this[0].numeric_id, null)
}

output "self_link" {
  description = "The URI of the created resource."
  value       = try(google_compute_network.this[0].self_link, null)
}


### Subnet Outputs ###

output "subnet_ids" {
  value = {
    for subnet_key, subnet in google_compute_subnetwork.this :
    subnet.name => {
      id              = subnet.id
      gateway_address = subnet.gateway_address
    }
  }
}

### Firewall Outputs ###
output "firewall_id" {
  description = "an identifier for the resource with format projects/{{project}}/global/firewalls/{{name}}"
  value       = try(values(google_compute_firewall.this)[*].id, [])
}

### Router Outputs ###
output "router_id" {
  description = "an identifier for the resource with format projects/{{project}}/regions/{{region}}/routers/{{name}}"
  value       = try(google_compute_router.this[0].id, null)
}

### NAT Outputs ###
output "nat_id" {
  description = "an identifier for the resource with format projects/{{project}}/regions/{{region}}/routers/{{router_name}}/nat"
  value       = try(google_compute_router_nat.this[0].id, null)
}