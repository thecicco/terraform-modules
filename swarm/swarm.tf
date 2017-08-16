variable "region" {}

variable "manager_number" {}
variable "manager_flavor" {}
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
  name = "swarm-worker"
  region = "${var.region}"
  quantity = "${var.worker_number}"
  flavor = "${var.worker_flavor}"
  image = "${var.ubuntu_complete_name}"
  external = "${var.worker_number}"
  role = "swarm"
  status = "worker"

  sec_group = ["${var.sec_group}"]
  network_name = "${var.network_name}"
  keypair = "${var.keypair}"
}

module "managers" {
  source = "../instances"
  name = "swarm-manager"
  region = "${var.region}"
  quantity = "${var.manager_number}"
  flavor = "${var.manager_flavor}"
  image = "${var.ubuntu_complete_name}"
  external = "${var.manager_number}"
  role = "swarm"
  status = "manager"
  
  sec_group = ["${var.sec_group}"]
  network_name = "${var.network_name}"
  keypair = "${var.keypair}"
}

