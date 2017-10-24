data "openstack_networking_network_v2" "public_network" {
  region = "${var.region}"
  name = "PublicNetwork"
}

resource "openstack_networking_network_v2" "internal-network" {
  region = "${var.region}"
  name = "${var.name}-network"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "internal-subnet" {
  region = "${var.region}"
  name = "${var.name}-subnet"
  network_id = "${openstack_networking_network_v2.internal-network.id}"
  cidr = "${var.internal-network-cidr}"
  ip_version = 4
  dns_nameservers = ["${var.dns1}","${var.dns2}"]
}

// if a router already exist do this 
resource "openstack_networking_router_interface_v2" "int-ext-interface-existing" {
  count = "${var.router_id != "" ? 1 : 0}"
  region = "${var.region}"
  router_id = "${var.router_id}"
  subnet_id = "${openstack_networking_subnet_v2.internal-subnet.id}"
}

// if a router does nit exist exist do this instead
resource "openstack_networking_router_v2" "router" {
  count = "${var.router_id != "" ? 0 : 1}"
  name = "router"
  region = "${var.region}"
  admin_state_up = "true"
  external_gateway = "${data.openstack_networking_network_v2.public_network.id}"
}

resource "openstack_networking_router_interface_v2" "int-ext-interface-internal" {
    count = "${var.router_id != "" ? 0 : 1}"
  region = "${var.region}"
  router_id = "${openstack_networking_router_v2.router.id}"
  subnet_id = "${openstack_networking_subnet_v2.internal-subnet.id}"
}

output "name" {
  value = "${openstack_networking_network_v2.internal-network.name}"
}

output "id" {
  value = "${openstack_networking_network_v2.internal-network.id}"
}

output "router_id" {
  value = "${openstack_networking_router_v2.router.id}"
}
