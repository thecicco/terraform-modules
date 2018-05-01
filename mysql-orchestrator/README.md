# Mysql orchestrator

boostrap must be defined only on first run, remember to set to false before the production usage.

```
module "my_ip" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.7-devel"
  name = "my_ip"
  protocol = ""
  allow_remote = "1.1.1.1/32"
}

module "mysql" {
  source = "github.com/entercloudsuite/terraform-modules//mysql-orchestrator?ref=2.7-devel"
  name = "myorchestrator"
  quantity = "3"
  bootstrap = "true" # set to false after the cluster completion
  external = "true"
  network_name = "default"
  sec_group = ["${module.my_ip.sg_id}"]
  keypair = "mykeypair"
  private_ssh_key = "${var.private_ssh_key}"
  mysql_port = "${var.mysql_port}"
  mysql_datadir = "${var.mysql_datadir}"
  mysql_admin_name = "myname"
  mysql_admin_password = "mypassword"
  mysql_replica_user_name = "replicaname"
  mysql_replica_user_password = "replicapassword"
  consul = "1.1.1.1"
  consul_datacenter = "moon"
  orchestrator_user = "orchestratorname"
  orchestrator_password = "orchestratorpassword"
}

variable "private_ssh_key" {
  default = <<EOF
-----BEGIN RSA PRIVATE KEY-----
-----END RSA PRIVATE KEY-----
EOF
}
```
