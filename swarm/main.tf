# Allow everything inside internal network
module "swarm_internal_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.4"
  name = "swarm_internal_sg"
  region = "${var.region}"
  protocol = ""
  allow_remote = "${var.network-internal-cidr}"
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
  source = "github.com/entercloudsuite/terraform-modules//instance?ref=2.4"
  name = "swarm_manager"
  image = "${var.image}"
  quantity = "${var.manager_count}"
  external = 0
  flavor = "${var.manager_flavor}"
  network_name = "${var.network_name}"
  sec_group = ["${module.swarm_internal_sg.sg_name}"]
  keypair = "${var.keyname}"
  userdata = "${data.template_file.docker-join.rendered}"
  tags = {
    "swarm_manager" = ""
    "server_group" = "SWARM"
  }
}

# Create Swarm worker instance(s)
module "swarm_worker" {
  source = "github.com/entercloudsuite/terraform-modules//instance?ref=2.4"
  name = "swarm_worker"
  image = "${var.image}"
  quantity = "${var.worker_count}"
  external = 0
  flavor = "${var.worker_flavor}"
  network_name = "${var.network_name}"
  sec_group = ["${module.swarm_internal_sg.sg_name}"]
  keypair = "${var.keyname}"
  userdata = "${data.template_file.docker-join.rendered}"
  tags = {
    "swarm_worker" = ""
    "server_group" = "SWARM"
  }
}

