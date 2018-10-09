# Create instance
module "wordpress" {
  source = "github.com/entercloudsuite/terraform-modules//instance?ref=2.7"
  name = "${var.name}"
  image = "ecs-docker 1.0.0"
  quantity = 1
  external = "true"
  flavor = "${var.flavor}"
  network_name = "${var.network_name}"
  sec_group = "${var.sec_group}"
  keypair = "${var.keypair}"
  tags = {
    "server_group" = "WEB"
  }
  userdata = "${data.template_file.cloud-config.*.rendered}"
  discovery = "${var.discovery}"
  region = "${var.region}"
}

data "template_file" "cloud-config" {
  template = "${file("cloud-config.yml")}"
  vars {
    db_password = "${var.db_password}"
  }
}
