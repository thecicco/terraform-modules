# Standalone
if consul variable is not defined this module create the instance as a mysql standalone

```
module "my_ip" {
  source = "github.com/entercloudsuite/terraform-modules//openstack/security?ref=2.7"
  name = "my_ip"
  protocol = ""
  allow_remote = "1.1.1.1/32"
}

module "mysql" {
  source = "github.com/entercloudsuite/terraform-modules//openstack/mysql?ref=2.7"
  name = "mysql"
  external = "true"
  network_name = "default"
  sec_group = ["${module.my_ip.sg_id}"]
  keypair = "default"
  mysql_admin_name = "myname"
  mysql_admin_password = "mypassword"
}
```
