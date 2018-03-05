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
module "kubernetes-ssh_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.6"
  name = "kubernetes-ssh"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 22
  port_range_max = 22
  allow_remote = "${var.access-cidr}"
}

module "kubernetes-all-tcp-from-internal_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.6"
  name = "kubernetes-all-tcp-from-internal"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 1
  port_range_max = 65535
  allow_remote = "${data.openstack_networking_subnet_v2.subnet.cidr}"
}

module "kubernetes-all-udp-from-internal_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.6"
  name = "kubernetes-all-udp-from-internal"
  region = "${var.region}"
  protocol = "udp"
  port_range_min = 1
  port_range_max = 65535
  allow_remote = "${data.openstack_networking_subnet_v2.subnet.cidr}"
}

# Cloud init scripts
data "template_file" "cloud-config-master" {
  template = "${file("${path.module}/kube-master.yml")}"
  vars {
    public-ip  = "${module.kubernetes_master.public-instance-address[0]}"
    kube-token = "${var.kube-token}"
  }
}

data "template_file" "cloud-config-worker" {
  template = "${file("${path.module}/kube-worker.yml")}"
  vars {
    master-ip  = "${module.kubernetes_master.instance-address[0]}"
    kube-token = "${var.kube-token}"
  }
}

# Kubernetes master node
module "kubernetes_master" {
  source = "github.com/entercloudsuite/terraform-modules//instance?ref=2.6"
  name = "kubernetes-master"
  region = "${var.region}"
  image = "${var.image}"
  quantity = 1
  external = "true"
  discovery = "true"
  flavor = "${var.master_flavor}"
  network_name = "${var.network_name}"
  sec_group = ["${module.kubernetes-ssh_sg.sg_id}","${module.kubernetes-all-tcp-from-internal_sg.sg_id}","${module.kubernetes-all-udp-from-internal_sg.sg_id}"]
  keypair = "${var.keyname}"
  userdata = "${data.template_file.cloud-config-master.rendered}"
  tags = {
    "server_group" = "KUBERNETES"
  }
}

# Kubernetes worker nodes
module "kubernetes_workers" {
  source = "github.com/entercloudsuite/terraform-modules//instance?ref=2.6"
  name = "kubernetes-workers"
  region = "${var.region}"
  image = "${var.image}"
  quantity = "${var.worker_count}"
  external = "false"
  discovery = "true"
  flavor = "${var.worker_flavor}"
  network_name = "${var.network_name}"
  sec_group = ["${module.kubernetes-all-tcp-from-internal_sg.sg_id}","${module.kubernetes-all-udp-from-internal_sg.sg_id}"]
  keypair = "${var.keyname}"
  userdata = "${data.template_file.cloud-config-worker.rendered}"
  tags = {
    "server_group" = "KUBERNETES"
  }
}
