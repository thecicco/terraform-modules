# Standalone

```
module "http" {
  source = "github.com/entercloudsuite/terraform-modules//openstack/security?ref=2.7"
  name = "http"
  region = "it-mil1"
  protocol = "http"
  allow_remote = "0.0.0.0/0"
}


module "elasticsearch-kibana-logs" {
  source = "github.com/entercloudsuite/terraform-modules//openstack/elasticsearch-kibana?ref=2.7"
  name = "es-logs"
  network_name = "default"
  sec_group = ["${module.http.sg_id}"]
  keypair = "my_key"
  consul = "consul.service.automium.consul"
  consul_datacenter = "automium"
  consul_encrypt = "supersecretconsul"
}
```


