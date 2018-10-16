resource "openstack_networking_secgroup_v2" "secgroup_public" {
    name = "${var.name}"
    description ="Security group ${var.name}"
    delete_default_rules = true
    region = "${var.region}"
}

output "sg_id" {
    value = "${openstack_networking_secgroup_v2.secgroup_public.id}"
}

output "sg_name" {
    value = "${openstack_networking_secgroup_v2.secgroup_public.name}"
}

resource "openstack_networking_secgroup_rule_v2" "in" {
    region = "${var.region}"
    direction = "ingress"
    ethertype = "IPv4"
    protocol = "${var.protocol}"
    port_range_min = "${var.port_range_min}"
    port_range_max = "${var.port_range_max}"
    remote_ip_prefix = "${var.allow_remote}"
    security_group_id = "${openstack_networking_secgroup_v2.secgroup_public.id}"
}

resource "openstack_networking_secgroup_rule_v2" "out" {
    region = "${var.region}"
    direction = "egress"
    ethertype = "IPv4"
    protocol = ""
    remote_ip_prefix = "0.0.0.0/0"
    security_group_id = "${openstack_networking_secgroup_v2.secgroup_public.id}"
}
