# Get network CIDR
data "openstack_networking_network_v2" "network" {
  name = "${var.network_name}"
  region = "${var.region}"
}

data "openstack_networking_subnet_v2" "subnet" {
  network_id = "${data.openstack_networking_network_v2.network.id}"
  region = "${var.region}"
}

# Create http firewall policy
module "haproxy_http_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.6"
  name = "haproxy_http_sg"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 80
  port_range_max = 80
  allow_remote = "0.0.0.0/0"
}

# Create https firewall policy
module "haproxy_https_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.6"
  name = "haproxy_https_sg"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 443
  port_range_max = 443
  allow_remote = "0.0.0.0/0"
}

# Create haproxy-stats firewall policy
module "haproxy_stats_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.6"
  name = "haproxy_stats_sg"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 8282
  port_range_max = 8282
  allow_remote = "0.0.0.0/0"
}

# Create internal firewall policy
module "haproxy_internal_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.6"
  name = "haproxy_internal_sg"
  region = "${var.region}"
  protocol = ""
  allow_remote = "${data.openstack_networking_subnet_v2.subnet.cidr}"
}

# Create multicast firewall policy
module "haproxy_multicast_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.6"
  name = "haproxy_multicast_sg"
  region = "${var.region}"
  protocol = ""
  allow_remote = "224.0.0.18/32"
}

# Create instance
module "haproxy" {
  source = "github.com/entercloudsuite/terraform-modules//instance?ref=2.6"
  name = "${var.name}"
  region = "${var.region}"
  image = "${var.image}"
  quantity = "${var.quantity}"
  external = "${var.external}"
  discovery = "true"
  flavor = "${var.flavor}"
  network_name = "${var.network_name}"
  sec_group = ["${module.haproxy_http_sg.sg_id}","${module.haproxy_https_sg.sg_id}","${module.haproxy_internal_sg.sg_id}","${module.haproxy_stats_sg.sg_id}","${module.haproxy_multicast_sg.sg_id}"]
  keypair = "${var.keyname}"
  tags = "${var.tags}"
}
