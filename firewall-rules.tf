resource "google_compute_firewall" "this" {
  for_each = var.firewall_rules

  name    = each.key
  network = google_compute_network.this[0].name
  project = var.project

  dynamic "allow" {
    for_each = each.value.allow != null ? each.value.allow : []

    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  dynamic "deny" {
    for_each = each.value.deny != null ? each.value.deny : []

    content {
      protocol = deny.value.protocol
      ports    = deny.value.ports
    }
  }
  description        = lookup(each.value, "description", null)
  destination_ranges = lookup(each.value, "destination_ranges", null)
  direction          = lookup(each.value, "direction", "INGRESS")
  disabled           = lookup(each.value, "disabled", false)

  dynamic "log_config" {
    for_each = each.value.log_config != null ? each.value.log_config : []
    content {
      metadata = log_config.value.metadata
    }
  }
  priority                = lookup(each.value, "priority", 1000)
  source_ranges           = lookup(each.value, "source_ranges", null)
  source_service_accounts = lookup(each.value, "source_service_accounts", null)
  source_tags             = lookup(each.value, "source_tags", null)
  target_service_accounts = lookup(each.value, "target_service_accounts", null)
  target_tags             = lookup(each.value, "target_tags", null)
  enable_logging          = lookup(each.value, "enable_logging", false)
}
