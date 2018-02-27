# Create ssh firewall policy
module "jenkins_ssh_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.6"
  name = "jenkins_ssh_sg"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 22
  port_range_max = 22
  allow_remote = "0.0.0.0/0"
}

# Create web firewall policy
module "jenkins_web_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.6"
  name = "jenkins_web_sg"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 8080
  port_range_max = 8080
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
module "jenkins_internal_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.6"
  name = "jenkins_internal_sg"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 1
  port_range_max = 65535
  allow_remote = "${data.openstack_networking_subnet_v2.subnet.cidr}"
}

# Create instance
module "jenkins_master" {
  source = "github.com/entercloudsuite/terraform-modules//instance?ref=2.6"
  name = "jenkins_master"
  region = "${var.region}"
  image = "${var.image}"
  quantity = 1
  external = "true"
  discovery = "false"
  flavor = "${var.master_flavor}"
  network_name = "${var.network_name}"
  sec_group = ["${module.jenkins_web_sg.sg_id}","${module.jenkins_internal_sg.sg_id}","${module.jenkins_ssh_sg.sg_id}"]
  keypair = "${var.keyname}"
  tags = {
    "server_group" = "JENKINS"
  }
}
