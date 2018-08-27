module "orchestrator" {
  source = "github.com/entercloudsuite/terraform-modules//instance?ref=2.7-devel"
  name = "${var.name}"
  quantity = "${var.quantity}"
  external = "${var.external}"
  region = "${var.region}"
  flavor = "${var.flavor}"
  network_name = "${var.network_name}"
  sec_group = "${var.sec_group}"
  discovery = "${var.discovery}"
  keypair = "${var.keypair}"
  userdata = "${data.template_file.cloud-config.*.rendered}"
  allowed_address_pairs = "${var.orchestrator_ip == "" ? "127.0.0.1" : var.orchestrator_ip}/32"
  tags = {
    "server_group" = "ORCHESTRATOR"
  }
}

data "template_file" "cloud-config" {
  template = "${file("${path.module}/cloud-config.yml")}"
  count = "${var.quantity}"
  vars {
    name = "${var.name}"
    number = "${count.index}"
    hostname = "${var.name}-${count.index}"
    orchestrator_port = "${var.orchestrator_port}" 
    orchestrator_service_port = "${var.orchestrator_service_port}" 
    orchestrator_user = "${var.orchestrator_user}" 
    orchestrator_password = "${var.orchestrator_password}" 
    orchestrator_raft_enabled = "${var.orchestrator_raft_enabled}" 
    orchestrator_raft_data_dir = "${var.orchestrator_raft_data_dir}" 
    orchestrator_raft_default_port = "${var.orchestrator_raft_default_port}" 
    orchestrator_raft_nodes = "${var.orchestrator_raft_nodes}" 
    consul = "${var.consul}" 
    consul_port = "${var.consul_port}" 
    consul_datacenter = "${var.consul_datacenter}" 
    consul_encrypt = "${var.orchestrator_encrypt}" 
  }
}

module "external_vip_web" {
  name = "${var.name}-vip"
  source = "github.com/entercloudsuite/terraform-modules//external_vip?ref=2.7-devel"
  external_vip = "${var.orchestrator_ip}"
  network_name = "${var.network_name}"
  discovery = "${var.discovery}"
}
