# Network data
data "openstack_networking_network_v2" "network" {
  name = "${var.network_name}"
  region = "${var.region}"
}

data "openstack_networking_subnet_v2" "subnet" {
  network_id = "${data.openstack_networking_network_v2.network.id}"
  region = "${var.region}"
}

module "kubernetes-all-from-internal_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.6"
  name = "kubernetes-all-from-internal"
  region = "${var.region}"
  protocol = ""
  allow_remote = "${data.openstack_networking_subnet_v2.subnet.cidr}"
}

# template heketi
data "template_file" "cloud-config-heketi" {
  template = "${file("${path.module}/kube-heketi.yml")}"
  count = "${var.heketi_count}"
  vars {
    name = "${var.heketi_name}"
    master-ip  = "${var.master-ip}"
    hostname = "${var.heketi_name}-${count.index}"
    heketi_admin_password = "${var.heketi_admin_password}"
    heketi_count = "${var.heketi_count}"
    kubernetes_master_name = "${var.kubernetes_master_name}"
    os_api_url = "${var.cloud_os_api_url}"
    os_tenant_name = "${var.cloud_os_tenant_name}"
    os_username = "${var.cloud_os_username}"
    os_password = "${var.cloud_os_password}"
    os_region = "${var.cloud_os_region}"
    heketi_heketi_container_version = "${var.heketi_heketi_container_version}"
    heketi_glusterfs_container_version = "${var.heketi_glusterfs_container_version}"
    heketi_namespace = "${var.heketi_namespace}"
    heketi_storageclass_arbiter = "${var.heketi_storageclass_arbiter}"
    heketi_storageclass_arbiter_average_file_size = "${var.heketi_storageclass_arbiter_average_file_size}"
    service-network-cidr = "${var.service-network-cidr}"
    dns-service-addr = "${cidrhost(var.service-network-cidr, 10)}"
    consul = "${var.consul}"
    consul_port = "${var.consul_port}"
    consul_datacenter = "${var.consul_datacenter}"
    consul_encrypt = "${var.consul_encrypt}"

  }
}

# Kubernetes Heketi nodes
module "kubernetes_heketi" {
  source = "github.com/entercloudsuite/terraform-modules//openstack/instance?ref=2.7"
  name = "${var.heketi_name}"
  region = "${var.region}"
  image = "${var.image}"
  quantity = "${var.heketi_count}"
  external = "false"
  discovery = "true"
  flavor = "${var.heketi_flavor}"
  network_name = "${var.network_name}"
  sec_group = "${concat(var.custom_secgroups_heketi, list("${module.kubernetes-all-from-internal_sg.sg_id}"))}"
  keypair = "${var.keyname}"
  userdata = "${data.template_file.cloud-config-heketi.*.rendered}"
  allowed_address_pairs = "0.0.0.0/0"
  postdestroy = "${data.template_file.heketi_cleanup.rendered}"
  tags = {
    "server_group" = "KUBERNETES"
  }
}

module "heketi-volume" {
  source = "github.com/entercloudsuite/terraform-modules//openstack/volume?ref=2.7"
  name = "${var.heketi_name}"
  size = "${var.heketi_volume_size}"
  instance = "${module.kubernetes_heketi.instance}"
  quantity = "${module.kubernetes_heketi.quantity}"
  region = "${var.region}"
  volume_type = "${var.heketi_volume_type}"
}

#+----------------------------------------------------------------------------+
#|                              C l e a n u p                                 |
#+----------------------------------------------------------------------------+

# cleanup heketi
data "template_file" "heketi_cleanup" {
  template = "${file("${path.module}/cleanup.sh")}"
  vars {
    name = "${var.heketi_name}"
    quantity = "${var.heketi_count}"
    consul = "${var.consul}"
    consul_port = "${var.consul_port}"
    consul_datacenter = "${var.consul_datacenter}"
    consul_encrypt = "${var.consul_encrypt}"
  }
}