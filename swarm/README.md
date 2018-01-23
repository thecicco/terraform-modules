# Swarm module  
## Start config
```
module "swarm" {
	source = "github.com/entercloudsuite/terraform-modules//swarm"
	region = "it-mil1"
	keyname = "${openstack_compute_keypair_v2.keypair.name}"
	network_name = "${openstack_networking_network_v2.production-internal-network.name}"
	image = "ecs-docker master"
	network-internal-cidr = "${var.production-internal-network-cidr}"
        manager_flavor = "e3standard.x2"
        worker_flavor = "e3standard.x4"
	// Parameters
	manager_count = 1
	worker_count = 0
	join_token = ""
	manager_ip = ""
}
```

### Steps:


1. Configure the parameters as below, adjust the flavor for your needs and run TF:   

```
        manager_count = 1
        worker_count = 0
        join_token = ""
        manager_ip = ""
```   

2. Login on the new Docker manager and obtain the manager join token, reconfigure the parameters as below and rerun TF:   

```
        manager_count = 3
        worker_count = 0
        join_token = "<Manager join token>"
        manager_ip = "<First manager private IP address>"
```
3. Login on a Docker manager, obtain the worker join token, reconfigure the parameters as below and rerun TF:   

```
        manager_count = 3
        worker_count = <the number of workers you need>
        join_token = "<Worker join token>"
        manager_ip = "<IP of a manager node>"
```

Done!
