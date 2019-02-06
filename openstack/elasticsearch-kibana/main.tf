# Create instance
module "elasticsearch-kibana" {
  source = "github.com/entercloudsuite/terraform-modules//openstack/instance?ref=2.7"
  name = "${var.name}"
  image = "ecs-elasticsearch 1.0.8"
  quantity = "1"
  flavor = "${var.flavor}"
  network_name = "${var.network_name}"
  sec_group = "${var.sec_group}"
  keypair = "${var.keypair}"
  tags = {
    "server_group" = "LOGGING"
  }
  userdata = "${data.template_file.cloud-config.*.rendered}"
  discovery = "${var.discovery}"
  external = "${var.external}"
  region = "${var.region}"
}

data "template_file" "cloud-config" {
  template = "${file("${path.module}/cloud-config.yml")}"
  vars {
  name = "${var.name}"
  consul = "${var.consul}"
  consul_port = "${var.consul_port}"
  consul_datacenter = "${var.consul_datacenter}"
  consul_encrypt = "${var.consul_encrypt}"
  }
}
