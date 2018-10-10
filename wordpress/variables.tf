variable "db_password" {
}

variable "db_host" {
}

variable "name" {
}

variable "sec_group" {
  type = "list"
}

variable "keypair" {
}

variable "flavor" {
  default = "e3standard.x3"
}

variable "network_name" {
}

variable "discovery" {
  default = "false"
}

variable "external" {
  default = "true"
}

variable "region" {
  default = "it-mil1"
}
