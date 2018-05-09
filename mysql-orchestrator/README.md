# Mysql orchestrator

boostrap must be defined only on first run, remember to set to false before the production usage.

```
module "mysql" {
  source = "github.com/entercloudsuite/terraform-modules//mysql-orchestrator?ref=2.7-devel"
  name = "myorchestrator"
  quantity = "3"
  bootstrap = "true" # set to false after the cluster completion
  external = "true"
  network_name = "default"
  sec_group = ["${module.my_ip.sg_id}","${module.orch_subnet.sg_id}"]
  keypair = "mykeypair"
  private_ssh_key = "${var.private_ssh_key}"
  mysql_ip = "192.168.0.216"
  mysql_subnet = "24"
  mysql_virtual_router_id = "10"
  orchestrator_ip = "192.168.0.217"
  orchestrator_subnet = "24"
  orchestrator_virtual_router_id = "11"
  mysql_admin_password = "mypassword"
  mysql_replica_user_password = "replicapassword"
  consul = "1.1.1.1"
  consul_datacenter = "moon"
  orchestrator_password = "orchestratorpassword"
}

module "orch_subnet" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.7-devel"
  name = "orch_subnet"
  protocol = ""
  allow_remote = "192.168.0.0/24"
}

module "my_ip" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.7-devel"
  name = "my_ip"
  protocol = ""
  allow_remote = "1.1.1.1/32"
}

variable "private_ssh_key" {
  default = <<EOF
-----BEGIN RSA PRIVATE KEY-----
-----END RSA PRIVATE KEY-----
EOF
}
```
