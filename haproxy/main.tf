
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
  keypair = "${var.keyname}"
  tags = "${var.tags}"
}