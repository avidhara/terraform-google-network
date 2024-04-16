resource "google_compute_network" "this" {
  count = var.create ? 1 : 0

  name                                      = var.name
  description                               = var.description
  project                                   = var.project
  auto_create_subnetworks                   = var.auto_create_subnetworks
  routing_mode                              = var.routing_mode
  mtu                                       = var.mtu
  enable_ula_internal_ipv6                  = var.enable_ula_internal_ipv6
  internal_ipv6_range                       = var.internal_ipv6_range
  network_firewall_policy_enforcement_order = var.network_firewall_policy_enforcement_order
  delete_default_routes_on_create           = var.delete_default_routes_on_create
}


resource "google_compute_subnetwork" "this" {
  for_each = var.subnets

  name          = each.value.subnet_name
  ip_cidr_range = each.value.ip_cidr_range
  network       = var.create ? google_compute_network.this[0].id : each.value.network
  project       = var.project
  description   = try(each.value, "description", null)
  purpose       = try(each.value, "purpose", null)
  role          = try(each.value, "role", null)
  dynamic "secondary_ip_range" {
    for_each = each.value.subnet_secondary_ip_ranges != null ? each.value.subnet_secondary_ip_ranges : []

    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }
  private_ipv6_google_access = try(each.value, "private_ipv6_google_access", null)
  private_ip_google_access   = try(each.value, "private_ip_google_access", "false")
  region                     = each.value.region


  dynamic "log_config" {
    for_each = each.value.log_config != null ? each.value.log_config : []
    content {
      aggregation_interval = try(log_config.value.aggregation_interval, null)
      flow_sampling        = try(log_config.value.flow_sampling, null)
      metadata             = try(log_config.value.metadata, null)
      metadata_fields      = log_config.value.metadata == "CUSTOM_METADATA" ? try(log_config.value.metadata_fields, null) : null
      filter_expr          = try(log_config.value.filter_expr, null)

    }
  }
  stack_type           = try(each.value, "stack_type", null)
  ipv6_access_type     = try(each.value, "ipv6_access_type", null)
  external_ipv6_prefix = try(each.value, "external_ipv6_prefix", null)
  # allow_subnet_cidr_routes_overlap = try(each.value, "allow_subnet_cidr_routes_overlap", false)

}
