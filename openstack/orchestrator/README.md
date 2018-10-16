# Standalone
if consul variable is not defined this module create the instance as a mysql standalone

```
module "mysql" {
  source = "github.com/entercloudsuite/terraform-modules//openstack/mysql?ref=2.7-devel"
  name = "mysql"
  external = "true"
  network_name = "default"
  sec_group = ["${module.internal.sg_id}"]
  keypair = "default"
  mysql_admin_name = "myname"
  mysql_admin_password = "mypassword"
}
```
