resource "google_compute_router_nat" "this" {
  count = var.create_router && var.create_router_nat ? 1 : 0

  project                            = var.project
  region                             = var.route_region
  name                               = var.nat_name
  router                             = google_compute_router.this[0].name
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat

  nat_ip_allocate_option = length(var.nat_ips) > 0 ? "MANUAL_ONLY" : "AUTO_ONLY"
  nat_ips                = var.nat_ips
  drain_nat_ips          = var.drain_nat_ips


  dynamic "subnetwork" {
    for_each = var.subnetworks
    content {
      name                     = subnetwork.value.name
      source_ip_ranges_to_nat  = subnetwork.value.source_ip_ranges_to_nat
      secondary_ip_range_names = contains(subnetwork.value.source_ip_ranges_to_nat, "LIST_OF_SECONDARY_IP_RANGES") ? subnetwork.value.secondary_ip_range_names : []
    }
  }

  min_ports_per_vm                 = var.min_ports_per_vm
  max_ports_per_vm                 = var.enable_dynamic_port_allocation ? var.max_ports_per_vm : null
  enable_dynamic_port_allocation   = var.enable_dynamic_port_allocation
  udp_idle_timeout_sec             = var.udp_idle_timeout_sec
  icmp_idle_timeout_sec            = var.icmp_idle_timeout_sec
  tcp_established_idle_timeout_sec = var.tcp_established_idle_timeout_sec
  tcp_transitory_idle_timeout_sec  = var.tcp_transitory_idle_timeout_sec
  tcp_time_wait_timeout_sec        = var.tcp_time_wait_timeout_sec

  dynamic "log_config" {
    for_each = var.log_config_enable == true ? [{
      enable = var.log_config_enable
      filter = var.log_config_filter
    }] : []

    content {
      enable = log_config.value.enable
      filter = log_config.value.filter
    }
  }
  # only available in beta
  #   endpoint_types = var.endpoint_types

  dynamic "rules" {
    for_each = var.rules
    content {
      rule_number = rules.value.rule_number
      match       = rules.value.match
      description = try(rules.value.description, null)

      dynamic "action" {
        for_each = try(rules.value.action, [])
        content {
          source_nat_active_ips = try(action.value.source_nat_active_ips, null)
          source_nat_drain_ips  = try(action.value.source_nat_drain_ips, null)
          # Only Available in Beta
          #   source_nat_active_ranges = try(action.value.source_nat_active_ranges, null)
          #   source_nat_drain_ranges  = try(action.value.source_nat_drain_ranges, null)
        }
      }
    }
  }


  enable_endpoint_independent_mapping = var.enable_endpoint_independent_mapping





}
