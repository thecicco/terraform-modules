# Create ssh firewall policy
module "postgres_ssh_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.6"
  name = "postgres_ssh_sg"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 22
  port_range_max = 22
  allow_remote = "0.0.0.0/0"
}

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
module "postgres_internal_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.6"
  name = "postgres_internal_sg"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 1
  port_range_max = 65535
  allow_remote = "${data.openstack_networking_subnet_v2.subnet.cidr}"
}

# Create instances
module "postgres" {
  source = "github.com/entercloudsuite/terraform-modules//instance?ref=2.6"
  name = "postgres"
  region = "${var.region}"
  image = "${var.image}"
  quantity = 1
  external = "false"
  discovery = "true"
  flavor = "${var.flavor}"
  network_name = "${var.network_name}"
  sec_group = ["${module.postgres_internal_sg.sg_id}","${module.postgres_ssh_sg.sg_id}"]
  keypair = "${var.keyname}"
  tags = {
    "server_group" = "POSTGRES"
  }
}

module "postgres_slaves" {
  source = "github.com/entercloudsuite/terraform-modules//instance?ref=2.6"
  name = "postgres-slaves"
  region = "${var.region}"
  image = "${var.image}"
  quantity = "${var.slave_count}
  external = "false"
  discovery = "true"
  flavor = "${var.flavor}"
  network_name = "${var.network_name}"
  sec_group = ["${module.postgres_internal_sg.sg_id}","${module.postgres_ssh_sg.sg_id}"]
  keypair = "${var.keyname}"
  tags = {
    "server_group" = "POSTGRES-SLAVES"
  }
}