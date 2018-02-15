# Create ssh firewall policy
module "jenkins_ssh_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.4"
  name = "jenkins_ssh_sg"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 22
  port_range_max = 22
  allow_remote = "0.0.0.0/0"
}

# Create web firewall policy
module "jenkins_web_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.4"
  name = "jenkins_web_sg"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 8080
  port_range_max = 8080
  allow_remote = "0.0.0.0/0"
}

# Create internal firewall policy
module "jenkins_internal_sg" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.4"
  name = "jenkins_internal_sg"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 1
  port_range_max = 65535
  allow_remote = "${var.network-internal-cidr}"
}

# Create instance
module "jenkins_master" {
  source = "github.com/entercloudsuite/terraform-modules//instance?ref=2.4"
  name = "jenkins_master"
  region = "${var.region}"
  image = "${var.image}"
  quantity = 1
  external = 1
  flavor = "${var.master_flavor}"
  network_name = "${var.network_name}"
  sec_group = ["${module.jenkins_web_sg.sg_id}","${module.jenkins_internal_sg.sg_id}","${module.jenkins_ssh_sg.sg_id}"]
  keypair = "${var.keyname}"
  tags = {
    "server_group" = "JENKINS"
  }
}
