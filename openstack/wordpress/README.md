# Standalone

```
module "http" {
  source = "github.com/entercloudsuite/terraform-modules//openstack/security?ref=2.7"
  name = "http"
  region = "${var.region}"
  protocol = "http"
  allow_remote = "0.0.0.0/0"
}

module "wordpress" {
  source = "github.com/entercloudsuite/terraform-modules//openstack/wordpress?ref=2.7"
  name = "wordpress"
  network_name = "${var.network_name}"
  sec_group = ["${module.http.sg_id}"]
  keypair = "${var.keypair_name}"
  db_host = "db"
  db_password = "yourverylongpasswordhere"
  consul = "consul.service.automium.consul"
  consul_datacenter = "automium"
  consul_encrypt = "supersecretconsul"
}
```
