variable "region" {}

variable "balancer_number" {}
variable "balancer_flavor" {}
variable "worker_number" {}
variable "worker_flavor" {}


variable "sec_group" {
  type    = "list"
}

variable "network_name" {}

variable "keypair" {}

variable "ubuntu_complete_name" {
  default = "GNU/Linux Ubuntu Server 16.04 Xenial Xerus x64"
}

module "workers" {
  source = "../instances"
  name = "elastic-worker"
  region = "${var.region}"
  quantity = "${var.worker_number}"
  flavor = "${var.worker_flavor}"
  image = "${var.ubuntu_complete_name}"
  external = "${var.worker_number}"
  role = "worker"
  status = "elastic"

  sec_group = ["${var.sec_group}"]
  network_name = "${var.network_name}"
  keypair = "${var.keypair}"
}

module "balancer" {
  source = "../instances"
  name = "elastic-balancer"
  region = "${var.region}"
  quantity = "${var.balancer_number}"
  flavor = "${var.balancer_flavor}"
  image = "${var.ubuntu_complete_name}"
  external = "${var.balancer_number}"
  role = "balancer"
  status = "elastic"
  
  sec_group = ["${var.sec_group}"]
  network_name = "${var.network_name}"
  keypair = "${var.keypair}"
}

