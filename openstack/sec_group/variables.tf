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
  default = "1"
}

variable "port_range_max" {
  default = "65535"
}

variable "remotes_ips_prefixes" {
  type = list(string)
}

variable "security_group_id" {
}

variable "region" {
  default = "it-mil1"
}
