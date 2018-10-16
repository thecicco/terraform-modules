# Standalone

```
module "http" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.7"
  name = "http"
  region = "it-mil1"
  protocol = "http"
  allow_remote = "0.0.0.0/0"
}


module "wp-site" {
  source = "github.com/entercloudsuite/terraform-modules//wordpress"
  name = "wp-vm"
  network_name = "default"
  sec_group = ["${module.http.sg_id}"]
  keypair = "my_key"
  db_password = "yourverylongpasswordhere"
}
```


