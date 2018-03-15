# Get network CIDR
data "openstack_networking_network_v2" "network" {
  name = "${var.network_name}"
  region = "${var.region}"
}

data "openstack_networking_subnet_v2" "subnet" {
  network_id = "${data.openstack_networking_network_v2.network.id}"
  region = "${var.region}"
}

# Allow everything inside internal network
module "swarm_internal_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.6"
  name = "swarm_internal_sg"
  region = "${var.region}"
  protocol = ""
  allow_remote = "${data.openstack_networking_subnet_v2.subnet.cidr}"
}

# Define cloud init
data "template_file" "docker-join" {
  template = "${file("${path.module}/docker-join.sh")}"
  vars {
    jointoken = "${var.join_token}"
    managerip = "${var.manager_ip}"
  }
}

# Create Swarm manager instances
module "swarm_manager" {
  source = "github.com/entercloudsuite/terraform-modules//instance?ref=2.6"
  name = "swarm_manager"
  region = "${var.region}"
  image = "${var.image}"
  quantity = "${var.manager_count}"
  external = "false"
  discovery = "false"
  flavor = "${var.manager_flavor}"
  network_name = "${var.network_name}"
  sec_group = ["${module.swarm_internal_sg.sg_id}"]
  keypair = "${var.keyname}"
  userdata = "${data.template_file.docker-join.rendered}"
  tags = {
    "swarm_manager" = ""
    "server_group" = "SWARM"
  }
}

# Create Swarm worker instance(s)
module "swarm_worker" {
  source = "github.com/entercloudsuite/terraform-modules//instance?ref=2.6"
  name = "swarm_worker"
  region = "${var.region}"
  image = "${var.image}"
  quantity = "${var.worker_count}"
  external = "false"
  discovery = "true"
  flavor = "${var.worker_flavor}"
  network_name = "${var.network_name}"
  sec_group = ["${module.swarm_internal_sg.sg_id}"]
  keypair = "${var.keyname}"
  userdata = "${data.template_file.docker-join.rendered}"
  tags = "${var.tags_worker}"
}

