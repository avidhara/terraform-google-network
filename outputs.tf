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

