# ECS Module for create HAproxy Standalone NO ha

Simple example

```

module "sg-haproxy-http" {
  source = "github.com/entercloudsuite/terraform-modules//openstack/security?ref=2.6"
  name = "haproxy-http"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 80
  port_range_max = 80
  allow_remote = "0.0.0.0/0"
}
module "sg-haproxy-https" {
  source = "github.com/entercloudsuite/terraform-modules//openstack/security?ref=2.6"
  name = "haproxy-https"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 443
  port_range_max = 443
  allow_remote = "0.0.0.0/0"
}

module "sg-haproxy-stats" {
  source = "github.com/entercloudsuite/terraform-modules//openstack/security?ref=2.6"
  name = "haproxy-stats"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 8282
  port_range_max = 8282
  allow_remote = "0.0.0.0/0"
}

data "openstack_networking_network_v2" "network" {
  name = "${var.network_name}"
  region = "${var.region}"
}

data "openstack_networking_subnet_v2" "subnet" {
  network_id = "${data.openstack_networking_network_v2.network.id}"
  region = "${var.region}"
}

module "haproxy-internal" {
  source = "github.com/entercloudsuite/terraform-modules//openstack/security?ref=2.7"
  name = "haproxy-internal"
  region = "${var.region}"
  protocol = ""
  allow_remote = "${data.openstack_networking_subnet_v2.subnet.cidr}"
}

module "haproxy" {
  source = "github.com/entercloudsuite/terraform-modules//openstack/haproxy?ref=2.7"
  name = "haproxy"
  quantity = 2
  region = "${var.region}"
  external = "true"
  network_name = "${var.network_name}"
  sec_group = ["${module.haproxy-internal.sg_id}","${module.sg-haproxy-http.sg_id}","${module.sg-haproxy-https.sg_id}","${module.sg-haproxy-stats.sg_id}"]
  keypair = "${var.keyname}"
  haproxy_user = "myusername"
  haproxy_pass = "myV3ryS3cr37Pass0rd"
  haproxy_conf = <<EOF
  listen web
  bind *:80
  option http-server-close
  option forwardfor
  default-server port 8081
     server web-0 10.2.0.23:8081 check
     server web-1 10.2.0.22:8081 check
  EOF
}

```
## Variables Description
| name | default |  Description |
| --- | --- | --- |
| quantity | 1 | Number of instance |
| name | haproxy | Instance Name
| sec_group | None | sg will associate te VM |
| keypair | None |keypair associate to VM |
| flavor | "e3standard.x2" | Instance flavor |
| external | flase | associate floating IP to VM |
| network_name | none | VM network |
| image | ecs-haproxy 1.1.4 | Whitch image deploy |
| discovery | true | register this VM in consul |
| region | it-mil1 | OS region |
| haproxy_user | None | HAproxy Stats UserName |
| haproxy_pass | None | HAproxy Stats Password |

### Name: haproxy_global  
 #### Default:
 ``` 
 EOF
  global
      log /dev/log local0
      log /dev/log local1 notice
      chroot /var/lib/haproxy
      stats socket /run/haproxy/admin.sock mode 660 level admin
      stats timeout 30s
      user haproxy
      group haproxy
      daemon
      maxconn 200000
      nbproc "{{ ansible_processor_vcpus }}"
  {% for n in range(ansible_processor_vcpus) %}
      cpu-map {{ n + 1 }} {{ n }}
  {% endfor %}
      ca-base /etc/ssl/certs
      crt-base /etc/ssl/private
      ssl-default-bind-ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS:!3DES
      ssl-default-bind-options no-sslv3
      tune.ssl.default-dh-param 2048
      EOF
```  

### Name: haproxy_defaults
#### Default:
```
  default = <<EOF
    defaults
      option log-health-checks
      mode    http
      option  dontlognull
      timeout connect 8000
      timeout client  60000
      timeout server  60000
      errorfile 400 /etc/haproxy/errors/400.http
      errorfile 403 /etc/haproxy/errors/403.http
      errorfile 408 /etc/haproxy/errors/408.http
      errorfile 500 /etc/haproxy/errors/500.http
      errorfile 502 /etc/haproxy/errors/502.http
      errorfile 503 /etc/haproxy/errors/503.http
      errorfile 504 /etc/haproxy/errors/504.http
      EOF
```
### Name: haproxy_stats  

#### Default:
```
EOF
listen stats
  bind *:8282
  mode http
 stats enable
 stats uri /
 stats realm Haproxy\ Statistics
 stats show-desc "HAProxy WebStatistics"
 stats show-node
 stats show-legends
 stats auth {{ haproxy_user }}:{{ haproxy_pass }}
 stats admin if TRUE
EOF
```

### Name: haproxy_conf
  #### Dafault: NoNe  
  #### Description: HAProxy configuration in HereDOC like haproxy_global or haproxy_defaults  
  #### Example  
  ```
  EOF
  listen web
  bind *:80
  option http-server-close
  option forwardfor
  default-server port 8081
     server web-0 10.2.0.23:8081 check
     server web-1 10.2.0.22:8081 check
  EOF
  ````
