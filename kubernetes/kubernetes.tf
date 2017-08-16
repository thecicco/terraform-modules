variable "region" {}

variable "master_number" {}
variable "master_flavor" {}
variable "kubelet_number" {}
variable "kubelet_flavor" {}


variable "sec_group" {
  type    = "list"
}
variable "network_name" {}
variable "keypair" {}

variable "ubuntu_complete_name" {
  default = "GNU/Linux Ubuntu Server 16.04 Xenial Xerus x64"
}

module "masters" {
  source = "../instances"
  name = "k8s-master"
  region = "${var.region}"
  quantity = "${var.master_number}"
  flavor = "${var.master_flavor}"
  image = "${var.ubuntu_complete_name}"
  external = 0
  role = "kubernetes"
  status = "master"
  
  sec_group = ["${var.sec_group}"]
  network_name = "${var.network_name}"
  keypair = "${var.keypair}"
}


module "kubelet" {
  source = "../instances"
  name = "k8s-kubelet"
  region = "${var.region}"
  quantity = "${var.kubelet_number}"
  flavor = "${var.kubelet_flavor}"
  image = "${var.ubuntu_complete_name}"
  external = 0
  role = "kubernetes"
  status = "kubelet"

  sec_group = ["${var.sec_group}"]
  network_name = "${var.network_name}"
  keypair = "${var.keypair}"
}


