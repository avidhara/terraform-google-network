resource "google_compute_route" "this" {
  for_each = var.routes

  name                   = each.key
  project                = var.project
  dest_range             = each.value.dest_range
  network                = google_compute_network.this[0].name
  description            = lookup(each.value, "description", null)
  priority               = lookup(each.value, "priority", 1000)
  next_hop_gateway       = lookup(each.value, "next_hop_gateway", null)
  next_hop_instance      = lookup(each.value, "next_hop_instance", null)
  next_hop_ip            = lookup(each.value, "next_hop_ip", null)
  next_hop_vpn_tunnel    = lookup(each.value, "next_hop_vpn_tunnel", null)
  next_hop_ilb           = lookup(each.value, "next_hop_ilb", null)
  next_hop_instance_zone = lookup(each.value, "next_hop_instance_zone", null)

  tags = lookup(each.value, "tags", null)

  depends_on = [var.module_depends_on]
}