variable "name" {}

variable "direction" {
  default = "ingress"
}

variable "ethertype" {
  default = "IPv4"
}

variable "protocol" {
  default = "tcp"
}

variable "port_range_min" {
}

variable "port_range_max" {
}

variable "remotes_ips_prefixes" {
  type = list(string)
}

variable "security_group_id" {
}

variable "region" {
  default = "it-mil1"
}
