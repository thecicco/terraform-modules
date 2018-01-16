resource "openstack_networking_floatingip_v2" "kube-master" {
  region = "${var.region}"
  count = 1
  pool = "${var.floating_ip_pool}"
}

resource "openstack_compute_floatingip_associate_v2" "fip_kubemaster" {
  region = "${var.region}"
  floating_ip = "${openstack_networking_floatingip_v2.kube-master.address}"
  instance_id = "${openstack_compute_instance_v2.kube-master.id}"
}

resource "openstack_compute_instance_v2" "kube-master" {
  region	  = "${var.region}"
  name            = "kube-master"
  image_name      = "${var.image}"
  flavor_name     = "${var.master_flavor}"
  key_pair        = "${var.keyname}"
  lifecycle {
    ignore_changes = ["user_data"]
  }

  security_groups = ["${openstack_compute_secgroup_v2.kube-master.name}"]
  user_data       = "${data.template_file.cloud-config-master.rendered}"

  network {
    uuid = "${var.network_uuid}"
  }

  metadata = {
    server_group = "${var.server_group}"
  }

}

resource "openstack_compute_instance_v2" "kube-slave" {
  region          = "${var.region}"
  name            = "kube-slave-${count.index+1}"
  count           = "${var.slave_count}"
  image_name      = "${var.image}"
  flavor_name     = "${var.master_flavor}"
  key_pair        = "${var.keyname}"
  lifecycle {
    ignore_changes = ["user_data"]
  }

  depends_on      = ["openstack_compute_instance_v2.kube-master"]

  security_groups = ["${openstack_compute_secgroup_v2.kube-slave.name}"]
  user_data       = "${element(data.template_file.cloud-config-slave.*.rendered, count.index)}"

  network {
    uuid = "${var.network_uuid}"
  }

  metadata = {
    server_group = "${var.server_group}"
  }

}

