variable "region" {}

variable "flavor" {}


variable "sec_group" {
  type    = "list"
}
variable "network_name" {}
variable "keypair" {}

variable "ubuntu_complete_name" {
  default = "GNU/Linux Ubuntu Server 16.04 Xenial Xerus x64"
}

module "bastion" {
  source = "../instances"
  name = "bastion"
  region = "${var.region}"
  quantity = 1
  flavor = "${var.flavor}"
  image = "${var.ubuntu_complete_name}"
  external = 1
  role = "bastion"
  status = "production"
  sec_group = ["${var.sec_group}"]
  network_name = "${var.network_name}"
  keypair = "${var.keypair}"
}
