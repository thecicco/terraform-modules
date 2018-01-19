# Create ssh firewall policy
module "prometheus_ssh_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.0"
  name = "prometheus_ssh_sg"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 22
  port_range_max = 22
  allow_remote = "0.0.0.0/0"
}

# Create web firewall policy
module "prometheus_web_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.0"
  name = "prometheus_web_sg"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 9090
  port_range_max = 9093
  allow_remote = "0.0.0.0/0"
}

# Create internal firewall policy
module "prometheus_internal_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.0"
  name = "prometheus_internal_sg"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 1
  port_range_max = 65535
  allow_remote = "${var.network-internal-cidr}"
}

# Create instance
module "prometheus" {
  source = "github.com/entercloudsuite/terraform-modules//instance?ref=2.0"
  name = "prometheus"
  image = "${var.image}"
  quantity = 1
  external = 1
  flavor = "${var.flavor}"
  network_name = "${var.network_name}"
  sec_group = ["${module.prometheus_web_sg.sg_name}","${module.prometheus_internal_sg.sg_name}","${module.prometheus_ssh_sg.sg_name}"]
  keypair = "${var.keyname}"
  tags = {
    "server_group" = "PROMETHEUS"
  }
}