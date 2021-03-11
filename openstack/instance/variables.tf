variable "name" {
}

variable "network_name" {
}

variable "flavor" {
}

variable "allowed_address_pairs" {
  default = "127.0.0.1/32"
}

variable "external" {
  default = "false"
}

variable "discovery" {
  default = "false"
}

variable "discovery_port" {
  default = 0
}

variable "quantity" {
  default = 1
}

variable "tags" {
  type = map(string)
  default = {
    role = "generic"
    status = "generic"
  }
}

variable "role" {
  default = "generic"
}

variable "status" {
  default = "generic"
}

variable "availability_zones" {
  default = ["nova"]
}

variable "region" {
  default = "it-mil1"
}

variable "image" {
  default = "ubuntu1804-1.0.0-4"
}

variable "image_uuid" {
  default = ""
}

variable "floating_ip_pool" {
  default = "PublicNetwork"
}

variable "sec_group" {
  type = list(string)
  default = []
}

variable "sec_group_per_instance" {
  type = set(string)
  default = []
}

variable "keypair" {
}

variable "userdata" {
  type = list(string)
  default = [""]
}

variable "postdestroy" {
  default = "true"
}

variable "auth_url" {
}

variable "tenant_name" {
}

variable "user_name" {
}

variable "password" {
}

variable "server_group_policy" {
  default = "anti-affinity"
}
