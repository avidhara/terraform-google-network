resource "google_compute_router" "this" {
  count = var.create_router ? 1 : 0

  name                          = var.router_name
  project                       = var.project
  region                        = var.route_region
  network                       = google_compute_network.this[0].name
  encrypted_interconnect_router = var.encrypted_interconnect_router

  dynamic "bgp" {
    for_each = var.bgp != null ? [var.bgp] : []
    content {
      asn               = bgp.value.asn
      advertise_mode    = try(bgp.value.advertise_mode, null)
      advertised_groups = try(bgp.value.advertised_groups, null)

      dynamic "advertised_ip_ranges" {
        for_each = try(bgp.value.advertised_ip_ranges, [])
        content {
          range       = advertised_ip_ranges.value.range
          description = try(advertised_ip_ranges.value.description, null)
        }
      }
      keepalive_interval = try(bgp.value.keepalive_interval, 20)
      ### Only Available in Beta
      #   identifier_range   = try(bgp.value.identifier_range, null)
    }
  }
}
