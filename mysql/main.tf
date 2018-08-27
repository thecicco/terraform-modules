module "mysql" {
  source = "github.com/entercloudsuite/terraform-modules//instance?ref=2.7-devel"
  name = "${var.name}"
  quantity = "${var.quantity}"
  external = "true"
  region = "${var.region}"
  flavor = "${var.flavor}"
  network_name = "${var.network_name}"
  sec_group = "${var.sec_group}"
  discovery = "${var.discovery}"
  keypair = "${var.keypair}"
  userdata = "${data.template_file.cloud-config.*.rendered}"
  allowed_address_pairs = "${var.mysql_ip}/32"
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
    mysql_root_name = "${var.mysql_root_name}"
    mysql_root_password = "${var.mysql_root_password}"
    mysql_admin_name = "${var.mysql_admin_name}"
    mysql_admin_password = "${var.mysql_admin_password}"
    mysql_datadir = "${var.mysql_datadir}"
  }
}
