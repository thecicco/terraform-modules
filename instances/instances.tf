variable "region" {}
variable "quantity" {}
variable "flavor" {}
variable "name" {}
variable "image" {}
variable "sec_group" {
  type    = "list"
}
variable "role" {}
variable "status" {}
variable "network_name" {}
variable "keypair" {}

variable "external" {}

variable "floating_ip_pool" {
  default = "PublicNetwork"
}

resource "openstack_networking_floatingip_v2" "ips" {
  region = "${var.region}"
  count = "${var.external}"
  pool = "${var.floating_ip_pool}"
}

resource "openstack_compute_servergroup_v2" "clusterSG" {
  region = "${var.region}"
  name     = "${var.name}"
  policies = ["anti-affinity"]
}

resource "openstack_compute_instance_v2" "cluster" {
  region = "${var.region}"
  count = "${var.quantity}"
  flavor_name = "${var.flavor}"
  name = "${var.name}-${count.index}"
  image_name = "${var.image}"
  key_pair = "${var.keypair}"
  security_groups = ["${var.sec_group}"]
  
  scheduler_hints {
    group = "${openstack_compute_servergroup_v2.clusterSG.id}"
  }

  network {
    name = "${var.network_name}"
  }

  metadata {
    role = "${var.role}"
    status = "${var.status}"
  }
}

resource "openstack_compute_floatingip_associate_v2" "external_ip" {
  region = "${var.region}"
  count = "${var.external}"
  floating_ip = "${element(openstack_networking_floatingip_v2.ips.*.address,count.index)}"
  instance_id = "${element(openstack_compute_instance_v2.cluster.*.id,count.index)}"
}