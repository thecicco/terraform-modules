# Create ssh firewall policy
module "postgres_ssh_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.5"
  name = "postgres_ssh_sg"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 22
  port_range_max = 22
  allow_remote = "0.0.0.0/0"
}

# Create internal firewall policy
module "postgres_internal_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.5"
  name = "postgres_internal_sg"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 1
  port_range_max = 65535
  allow_remote = "${var.network-internal-cidr}"
}

# Create instance
module "postgres" {
  source = "github.com/entercloudsuite/terraform-modules//instance?ref=2.5"
  name = "postgres"
  region = "${var.region}"
  image = "${var.image}"
  quantity = 1
  flavor = "${var.flavor}"
  network_name = "${var.network_name}"
  sec_group = ["${module.postgres_internal_sg.sg_id}","${module.postgres_ssh_sg.sg_id}"]
  keypair = "${var.keyname}"
  tags = {
    "server_group" = "POSTGRES"
  }
}
