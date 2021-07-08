terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}


resource "openstack_networking_secgroup_rule_v2" "rule" {
    region = var.region
    count = length(var.remotes_ips_prefixes)
    direction = var.direction
    ethertype = var.ethertype
    protocol = var.protocol
    port_range_min    = var.port_range_min
    port_range_max    = var.port_range_max
    remote_ip_prefix = element(var.remotes_ips_prefixes, count.index)
    security_group_id = var.security_group_id
}
