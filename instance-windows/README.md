# terraform-module-windows

## Example

### Create instance

1. Write the example below in a .tf file

```
variable "region" {
  default = "<your-region>"
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

module "windows" {
  source = "github.com/entercloudsuite/terraform-module//instance-windows?ref=2.7"
  name = "windows"
  quantity = 1
  external = "true"
  image = "<your-windows-image>"
  flavor = "e3standard.x4"
  network_name = "${var.network_name}"
  sec_group = ["${module.instance-web-sg.sg_id}"]
  keypair = "${var.keypair_name}"
  password = "<your-password>"
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
