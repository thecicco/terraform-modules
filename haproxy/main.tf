# Create ssh firewall policy
module "haproxy_ssh_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.0"
  name = "haproxy_ssh_sg"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 22
  port_range_max = 22
  allow_remote = "0.0.0.0/0"
}

# Create web firewall policy
module "haproxy_web_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.0"
  name = "haproxy_web_sg"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 80
  port_range_max = 80
  allow_remote = "0.0.0.0/0"
}

# Create internal firewall policy
module "haproxy_internal_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.0"
  name = "haproxy_internal_sg"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 1
  port_range_max = 65535
  allow_remote = "${var.network-internal-cidr}"
}

# Create instance
module "haproxy" {
  source = "github.com/entercloudsuite/terraform-modules//instance?ref=2.0"
  name = "haproxy"
  region = "${var.region}"
  image = "${var.image}"
  quantity = 1
  external = 1
  flavor = "${var.flavor}"
  network_name = "${var.network_name}"
  sec_group = ["${module.haproxy_web_sg.sg_name}","${module.haproxy_internal_sg.sg_name}","${module.haproxy_ssh_sg.sg_name}"]
  keypair = "${var.keyname}"
  tags = {
    "server_group" = "HAPROXY"
  }
}
