variable "vcd_username" {
}

variable "vcd_password" {
}

variable "vcd_url" {
}

variable "vcd_org" {
}

variable "vcd_vdc" {
}

variable "vcd_server" {
}

variable "quantity" {
  default = 3
}

variable "consul" {
  default = ""
}

variable "consul_port" {
  default = "8500"
}


variable "name" {
  default = "etcd-server"
}

variable "network_name" {}

variable "template" {}

variable "keypair" {}

variable "catalog" {
}

variable "cpus" {
  default = 2
}

variable "memory" {
  default = 4096
}
variable "consul_datacenter" {
}

variable "consul_encrypt" {
}

