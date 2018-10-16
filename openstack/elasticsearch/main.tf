# Get network CIDR
data "openstack_networking_network_v2" "network" {
  name = "${var.network_name}"
  region = "${var.region}"
}

data "openstack_networking_subnet_v2" "subnet" {
  network_id = "${data.openstack_networking_network_v2.network.id}"
  region = "${var.region}"
}

# Create internal firewall policy
module "elasticsearch_internal_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.6"
  name = "elasticsearch_internal_sg"
  region = "${var.region}"
  protocol = ""
  allow_remote = "${data.openstack_networking_subnet_v2.subnet.cidr}"
}

# Create instance
module "elasticsearch" {
  source = "github.com/entercloudsuite/terraform-modules//instance?ref=2.6"
  name = "elasticsearch"
  region = "${var.region}"
  image = "${var.image}"
  quantity = "${var.quantity}"
  external = "false"
  discovery = "true"
  flavor = "${var.flavor}"
  network_name = "${var.network_name}"
  sec_group = ["${module.elasticsearch_internal_sg.sg_id}"]
  keypair = "${var.keyname}"
  tags = "${var.tags}"
}
