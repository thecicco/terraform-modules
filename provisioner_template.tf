provider "openstack" {
  auth_url = "https://api.${var.region}.entercloudsuite.com/v2.0"
  tenant_name = "${var.tenant_name}"
  user_name = "${var.username}"
  password = "${var.password}"
}

// options: "nl-ams1" , "it-mil1", "de-fra1"
variable "region" {
  default = ""
}

variable "tenant_name" {
  default = ""
}

variable "username" {
  default = ""
}

variable "password" {
  default = ""
}

variable "ssh_pubkey" {
  default = "private.pem.pub"
}

variable "ssh_privkey" {
  default = "private.pem"
}

resource "openstack_compute_keypair_v2" "keypair" {
  name = "aickey"
  public_key = "${file(var.ssh_pubkey)}"
  region = "${var.region}"
}

terraform {
  required_version = "> 0.9.5"
}