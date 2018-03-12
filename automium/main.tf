# Create default network
module "network" {
  source = "github.com/entercloudsuite/terraform-modules//network?ref=2.6"
  region = "${var.region}"
  name = "default"
  router_id = ""
}

# Create mngmt security group
module "bastion_mngmt_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.6"
  name = "bastion_mngmt_sg"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 1
  port_range_max = 65535
  allow_remote = "${var.cidr}"
}

# Create internal security group
module "bastion_internal_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.6"
  name = "bastion_internal_sg"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 1
  port_range_max = 65535
  allow_remote = "10.2.0.0/16"
}

# Create instance
module "bastion" {
  source = "github.com/entercloudsuite/terraform-modules//instance?ref=2.6"
  name = "bastion"
  region = "${var.region}"
  image = "${var.image}"
  quantity = 1
  external = "true"
  flavor = "${var.flavor}"
  network_name = "${module.network.name}"
  sec_group = ["${module.bastion_mngmt_sg.sg_id}","${module.bastion_internal_sg.sg_id}"]
  keypair = "${var.keyname}"
  tags = {
    "server_group" = "BASTION"
  }
}
