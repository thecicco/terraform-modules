resource "openstack_compute_secgroup_v2" "kube-master" {
  region = "${var.region}"
  name = "kube-master"
  description = "Kube Master Node"

  # SSH Access
  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "${var.access_cidr}"
  }

  # Access to/from Kube Network
  rule {
    from_port   = 1
    to_port     = 65535
    ip_protocol = "tcp"
    cidr        = "${var.network-internal-cidr}"
  }

  rule {
    from_port   = 1
    to_port     = 65535
    ip_protocol = "udp"
    cidr        = "${var.network-internal-cidr}"
  }

  # Access to random ports
  rule {
    from_port   = 30000
    to_port     = 65535
    ip_protocol = "tcp"
    cidr        = "${var.access_cidr}"
  }

}

resource "openstack_compute_secgroup_v2" "kube-slave" {
  region = "${var.region}"
  name = "kube-slave"
  description = "Kube Slave Nodes"

  # Full Access from local cidr
  rule {
    from_port   = 1
    to_port     = 65535
    ip_protocol = "tcp"
    cidr        = "${var.network-internal-cidr}"
  }

  rule {
    from_port   = 1
    to_port     = 65535
    ip_protocol = "udp"
    cidr        = "${var.network-internal-cidr}"
  }

}

