resource "google_compute_subnetwork" "this" {
  for_each = var.subnets

  name          = each.key
  ip_cidr_range = each.value.ip_cidr_range
  network       = var.create ? google_compute_network.this[0].id : each.value.network
  project       = var.project
  description   = lookup(each.value, "description", null)
  purpose       = lookup(each.value, "purpose", "PRIVATE_RFC_1918")
  role          = lookup(each.value, "role", null)
  dynamic "secondary_ip_range" {
    for_each = each.value.secondary_ip_range != null ? each.value.secondary_ip_range : []

    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }
  private_ipv6_google_access = lookup(each.value, "private_ipv6_google_access", null)
  private_ip_google_access   = lookup(each.value, "private_ip_google_access", "false")
  region                     = each.value.region


  dynamic "log_config" {
    for_each = each.value.log_config != null ? each.value.log_config : []
    content {
      aggregation_interval = lookup(log_config.value.aggregation_interval, null)
      flow_sampling        = lookup(log_config.value.flow_sampling, null)
      metadata             = lookup(log_config.value.metadata, null)
      metadata_fields      = log_config.value.metadata == "CUSTOM_METADATA" ? lookup(log_config.value.metadata_fields, null) : null
      filter_expr          = lookup(log_config.value.filter_expr, null)

    }
  }
  stack_type           = lookup(each.value, "stack_type", null)
  ipv6_access_type     = lookup(each.value, "ipv6_access_type", null)
  external_ipv6_prefix = lookup(each.value, "external_ipv6_prefix", null)
  # allow_subnet_cidr_routes_overlap = try(each.value, "allow_subnet_cidr_routes_overlap", false)
}
