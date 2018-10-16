# Create instance
module "wordpress" {
  source = "github.com/entercloudsuite/terraform-modules//openstack/instance?ref=2.7"
  name = "${var.name}"
  image = "ecs-docker 1.0.0"
  quantity = "${var.quantity}"
  flavor = "${var.flavor}"
  network_name = "${var.network_name}"
  sec_group = "${var.sec_group}"
  keypair = "${var.keypair}"
  tags = {
    "server_group" = "WEB"
  }
  userdata = "${data.template_file.cloud-config.*.rendered}"
  discovery = "${var.discovery}"
  external = "${var.external}"
  region = "${var.region}"
}

data "template_file" "cloud-config" {
  template = "${file("${path.module}/cloud-config.yml")}"
  vars {
    db_password = "${var.db_password}"
    db_host = "${var.db_host}"
  }
}
