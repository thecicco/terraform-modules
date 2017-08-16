module "network" {
  source = "github.com/entercloudsuite/terraform-modules//network"
  region = "${var.region}"
  name = "general_network"
  router_id = ""
}

module "sec_public" {
  source = "github.com/entercloudsuite/terraform-modules//security"
  name = "from_all"
  region = "${var.region}"
  allow_remote = "0.0.0.0/0"
}

module "random-istance" {
  source = "github.com/entercloudsuite/terraform-modules//instances"
  name = "bastion"
  region = "${var.region}"
  quantity = 1
  flavor = "${var.flavor}"
  image = "${var.ubuntu_complete_name}"
  external = 1
  role = "bastion"
  status = "production"
  sec_group = ["${var.sec_group}"]
  network_name = "${var.network_name}"
  keypair = "${var.keypair}"
}

module "cluster-swarm" {
  source = "github.com/entercloudsuite/terraform-modules//swarm"
  region = "${var.region}"
  manager_number = 0
  manager_flavor = "e3standard.x2"
  worker_number = 0
  worker_flavor = "e3standard.x1"
  network_name = "${module.network.name}"
  sec_group = ["${module.sec_public.sg_id}"]
  keypair = "${openstack_compute_keypair_v2.keypair.name}"
}

module "cluster-k8s" {
  source = "github.com/entercloudsuite/terraform-modules//kubernetes"
  region = "${var.region}"
  master_number = 0
  master_flavor = "e3standard.x3"
  kubelet_number = 0
  kubelet_flavor = "e3standard.x2"
  network_name = "${module.network.name}"
  sec_group = ["${module.sec_public.sg_id}"]
  keypair = "${openstack_compute_keypair_v2.keypair.name}"
}

module "elastic" {
   source = "github.com/entercloudsuite/terraform-modules//elastic"
   region = "${var.region}"
   balancer_number = 0
   balancer_flavor = "e3standard.x5"
   worker_number = 0
   worker_flavor = "e3standard.x4"
   network_name = "${module.network.name}"
   sec_group = ["${module.sec_public.sg_id}"]
   keypair = "${openstack_compute_keypair_v2.keypair.name}"
}

module "bastion" {
  source = "github.com/entercloudsuite/terraform-modules//bastion"
  region = "${var.region}"
  flavor = "e3standard.x1"
  network_name = "${module.network.name}"
  sec_group = ["${module.sec_public.sg_id}"]
  keypair = "${openstack_compute_keypair_v2.keypair.name}"
}

// module "snapE1X1" {
//   source = "github.com/entercloudsuite/terraform-modules//snapshots"
//   region = "${var.region}"
//   flavor = "e1standard.x1"
//   network_name = "${module.network.name}"
//   sec_group = ["${module.sec_public.sg_id}"]
//   keypair = "${openstack_compute_keypair_v2.keypair.name}"
// }