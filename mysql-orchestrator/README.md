# Mysql orchestrator

boostrap must be defined only on first run, remember to set to false before the production usage.

```
module "mysql" {
  source = "github.com/entercloudsuite/terraform-modules//mysql-orchestrator?ref=2.7-devel"
  name = "myorchestrator"
  quantity = "3"
  external = "true"
  network_name = "default"
  sec_group = ["${module.my_ip.sg_id}","${module.orch_subnet.sg_id}"]
  keypair = "mykeypair"
  private_ssh_key = "${var.private_ssh_key}"
  mysql_admin_password = "mypassword"
  mysql_replica_user_password = "replicapassword"
  consul = "consul.service.moon.consul"
  consul_datacenter = "moon"
  consul_encrypt = "2MHWRwUeaw9zMVZ+QuLuBA=="
  orchestrator_password = "orchestratorpassword"
}
```
