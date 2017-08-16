
variable "region" {}
variable "name" {}
variable "allow_remote" {}

resource "openstack_networking_secgroup_v2" "secgroup_public" {
    name = "${var.name}"
    description = "This is the public security group with everything open"
    delete_default_rules = true
    region = "${var.region}"
}

output "sg_id" {
    value = "${openstack_networking_secgroup_v2.secgroup_public.id}"
}

output "sg_name" {
    value = "${openstack_networking_secgroup_v2.secgroup_public.name}"
}

resource "openstack_networking_secgroup_rule_v2" "in_everything_tcp" {
    region = "${var.region}"
    direction = "ingress"
    ethertype = "IPv4"
    protocol = "tcp"
    port_range_min = 1
    port_range_max = 65535
    remote_ip_prefix = "${var.allow_remote}"
    security_group_id = "${openstack_networking_secgroup_v2.secgroup_public.id}"
}

resource "openstack_networking_secgroup_rule_v2" "in_everything_udp" {
    region = "${var.region}"
    direction = "ingress"
    ethertype = "IPv4"
    protocol = "udp"
    port_range_min = 1
    port_range_max = 65535
    remote_ip_prefix = "${var.allow_remote}"
    security_group_id = "${openstack_networking_secgroup_v2.secgroup_public.id}"
}


resource "openstack_networking_secgroup_rule_v2" "out_everything_tcp" {
    region = "${var.region}"
    direction = "egress"
    ethertype = "IPv4"
    protocol = "tcp"
    port_range_min = 1
    port_range_max = 65535
    remote_ip_prefix = "${var.allow_remote}"
    security_group_id = "${openstack_networking_secgroup_v2.secgroup_public.id}"
}

resource "openstack_networking_secgroup_rule_v2" "out_everything_udp" {
    region = "${var.region}"
    direction = "egress"
    ethertype = "IPv4"
    protocol = "udp"
    port_range_min = 1
    port_range_max = 65535
    remote_ip_prefix = "${var.allow_remote}"
    security_group_id = "${openstack_networking_secgroup_v2.secgroup_public.id}"
}

