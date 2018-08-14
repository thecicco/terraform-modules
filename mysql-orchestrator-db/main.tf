module "mysql" {
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
  allowed_address_pairs = "${var.mysql_ip == "" ? "127.0.0.1" : var.mysql_ip}/32"
  tags = {
    "server_group" = "MYSQL"
  }
}

data "template_file" "cloud-config" {
  template = "${file("${path.module}/cloud-config.yml")}"
  count = "${var.quantity}"
  vars {
    name = "${var.name}"
    number = "${count.index}"
    hostname = "${var.name}-${count.index}"
    mysql_ip = "${var.mysql_ip}"
    mysql_subnet = "${var.mysql_subnet}"
    mysql_port = "${var.mysql_port}"
    mysql_master_port = "${var.mysql_master_port}"
    mysql_slaves_port = "${var.mysql_slaves_port}"
    mysql_virtual_router_id = "${var.mysql_virtual_router_id}"
    mysql_root_name = "${var.mysql_root_name}"
    mysql_root_password = "${var.mysql_root_password}"
    mysql_admin_name = "${var.mysql_admin_name}"
    mysql_admin_password = "${var.mysql_admin_password}"
    mysql_replica_user_name = "${var.mysql_replica_user_name}"
    mysql_replica_user_password = "${var.mysql_replica_user_password}"
    consul = "${var.consul}" 
    consul_port = "${var.consul_port}" 
    consul_datacenter = "${var.consul_datacenter}" 
    orchestrator = "${var.orchestrator}" 
    orchestrator_port = "${var.orchestrator_port}" 
    orchestrator_user = "${var.orchestrator_user}" 
    orchestrator_password = "${var.orchestrator_password}" 
    orchestrator_cluster_name = "${var.orchestrator_cluster_name}" 
    private_ssh_key = "${indent(16,var.private_ssh_key)}"
    mysql_datadir = "${var.mysql_datadir}"
  }
}

module "external_vip_web" {
  name = "${var.name}-vip"
  source = "github.com/entercloudsuite/terraform-modules//external_vip?ref=2.7-devel"
  external_vip = "${var.mysql_ip}"
  network_name = "${var.network_name}"
  discovery = "${var.discovery}"
}

module "volume-mysql" {
  source = "github.com/entercloudsuite/terraform-modules//volume?ref=2.6"
  name = "${var.name}"
  size = "${var.mysql_volume_size}"
  instance = "${module.mysql.instance}"
  quantity = "${module.mysql.quantity}"
  volume_type = "${var.mysql_volume_type}"
}
