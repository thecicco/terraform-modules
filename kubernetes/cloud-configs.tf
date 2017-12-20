data "template_file" "cloud-config-master" {
  template = "${file("${path.module}/kube-master.yml")}"
  vars {
    public-ip  = "${openstack_networking_floatingip_v2.kube-master.address}"
    kube-token = "${var.kube-token}"
    pod-network-cidr = "${var.pod-network-cidr}"
    service-cidr = "${var.service-cidr}"
  }
}

data "template_file" "cloud-config-slave" {
  count = "${var.slave_count}"
  template = "${file("${path.module}/kube-slave.yml")}"

  vars {
    hostname   = "${format("kube-slave-%02d", count.index + 1)}"
    master-ip  = "${openstack_compute_instance_v2.kube-master.network.0.fixed_ip_v4}"
    kube-token = "${var.kube-token}"
  }

}
