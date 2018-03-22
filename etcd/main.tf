# Network data
data "openstack_networking_network_v2" "network" {
  name = "${var.network_name}"
  region = "${var.region}"
}

data "openstack_networking_subnet_v2" "subnet" {
  network_id = "${data.openstack_networking_network_v2.network.id}"
  region = "${var.region}"
}

# Security groups
module "etcd-all-tcp-from-internal_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.6"
  name = "etcd-all-tcp-from-internal"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 1
  port_range_max = 65535
  allow_remote = "${data.openstack_networking_subnet_v2.subnet.cidr}"
}

module "etcd-all-udp-from-internal_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.6"
  name = "etcd-all-udp-from-internal"
  region = "${var.region}"
  protocol = "udp"
  port_range_min = 1
  port_range_max = 65535
  allow_remote = "${data.openstack_networking_subnet_v2.subnet.cidr}"
}

# Cluster Token
resource "random_string" "cluster-token" {
    length = 32
    special = false
}

# Cloud init template
data "template_file" "etcd-cloudinit" {
    template = "${file("${path.module}/etcd-cloudinit.yml")}"
    vars {
        etcd_token = "${random_string.cluster-token.result}"
    }
}

# etcd instances
module "etcd-server" {
  source = "github.com/entercloudsuite/terraform-modules//instance?ref=2.6"
  name = "etcd-server"
  quantity = 3
  external = "false"
  discovery = "true"
  discovery_port = 2380
  flavor = "${var.flavor}"
  network_name = "${var.network_name}"
  sec_group = ["${module.etcd-all-tcp-from-internal_sg.sg_id}","${module.etcd-all-udp-from-internal_sg.sg_id}"]
  keypair = "${var.keyname}"
  region = "${var.region}"
  userdata = "${data.template_file.etcd-cloudinit.rendered}"
  tags = {
    "server_group" = "ETCD"
  }
}

# etcd cluster token output
output "cluster-token" {
    value = "${random_string.cluster-token.result}"
}