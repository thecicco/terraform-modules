# ECS Terraform Modules

## Example

### Create instance

1. Write the example below in a .tf file

```
# Choose between it-mil1, de-fra1 and nl-ams1
variable "region" {
  default = "it-mil1"
}

# Your tenant name
variable "tenant_name" {
  default = "test@test.com"
}

# Your user name
variable "username" {
  default = "test@test.com"
}

# Your password
variable "password" {
  default = "test"
}

# You ssh public key path
variable "ssh_pubkey" {
  default = "../id.rsa"
}

# Define provider
provider "openstack" {
  auth_url = "auth_url"
  tenant_name = "tenant_name"
  user_name = "user_name"
  password = "password"
}

# Create network
module "network" {
  source = "github.com/entercloudsuite/terraform-modules//network?ref=2.6"
  region = "${var.region}"
  name = "general_network"
  router_id = ""
}

# Create ssh keypair
module "keypair" {
  source = "github.com/entercloudsuite/terraform-modules//keypair?ref=2.6"
  ssh_pubkey = "${var.ssh_pubkey}"
  region = "${var.region}"
}

# Create ssh firewall policy
module "ssh" {
  source = "github.com/entercloudsuite/terraform-modules//security?ref=2.6"
  name = "ssh"
  region = "${var.region}"
  protocol = "tcp"
  port_range_min = 22
  port_range_max = 22
  allow_remote = "0.0.0.0/0"
}

# Create instance
module "web" {
  source = "github.com/entercloudsuite/terraform-modules//instance?ref=2.6"
  name = "web"
  quantity = 1
  external = "true"
  flavor = "e3standard.x3"
  network_name = "${module.network.name}"
  sec_group = ["${module.ssh.sg_id}"]
  keypair = "${module.keypair.name}"
  tags = {
    "icinga2_client" = "" # If you integrate with icinga2 role
    "server_group" = "WEB"
  }
}
```

2. Change the variables with your data:
* region
* tenant_name
* username
* password
* ssh_pubkey <- you can generate it with ssh-keygen command

3. compile provider "openstack" section, don't use the variables here
4. Adjust the `quantity` variable to a desirable value
5. Run `terraform init` to allow terraform to get the requirements
6. Run `terraform get` to allow terraform to obtain the modules
7. Run `terraform plan -out plan.tfplan` and `terraform apply plan.tfplan` to provision the infrastructure

### Create Volume

1. Add the snippet below to your .tf file

```
# Create volume for each web instance
module "volume-web" {
  source = "github.com/entercloudsuite/terraform-modules//volume"
  device = "/dev/vdb" # Or not include to have an automatic mount point
  name = "volume-web"
  size = "10"
  instance = "${module.web.instance}"
  quantity = "${module.web.quantity}"
  volume_type = "Top"
}
```

2. Adjust the `size` variable to a desirable value
3. Run `terraform get` to allow terraform to obtain the modules
4. Run `terraform plan` and `terraform apply` to provision the infrastructure

### Remote tf state

1. Add the snippet below to your .tf file
```
terraform {
  backend "swift" {
    auth_url = "https://api.it-mil1.entercloudsuite.com/v2.0"
    password = "test"
    container = "terraform_it-mil1_state"
    region_name = "it-mil1"
    tenant_name = "test@test.com"
    user_name = "test@test.com"
  }
}
```
2. Change the variables with your data:
* auth_url
* region
* tenant_name
* username
* password


### External vip

Expose vip with a floating ip

```
module "external_vip_web" {
  source = "github.com/entercloudsuite/terraform-modules//external_vip?ref=2.6"
  external_vips = ["10.2.255.1","10.2.255.2"]
  network_id = "${module.network.id}"
  subnet = "${module.network.subnet_id}"
}
```

## Note
This project is still in development, more documentation and modules will be added in the future. Stay tuned!
