variable "quantity" {
  default = 1
}

variable "bootstrap" {
  default = "false"
}

variable "name" {
  default = "mysql"
}

variable "mysql_vip" {
  default = "false"
}

variable "mysql_ip" {
  default = "1.1.1.1"
}

variable "mysql_subnet" {
  default = ""
}

variable "mysql_port" {
  default = "3306"
}

variable "orchestrator" {
  default = ""
}

variable "orchestrator_port" {
  default = "3000"
}

variable "orchestrator_cluster_name" {
  default = ""
}

variable "consul" {
  default = ""
}

variable "consul_port" {
  default = "8500"
}

variable "consul_datacenter" {
  default = ""
}

variable "mysql_root_name" {
  default = "root"
}

variable "mysql_root_password" {
  default = "root"
}

variable "mysql_admin_name" {
  default = "admin"
}

variable "mysql_admin_password" {
}

variable "mysql_replica_user_name" {
  default = "replica"
}

variable "mysql_replica_user_password" {
  default = ""
}

variable "orchestrator_user" {
  default = ""
}

variable "orchestrator_password" {
  default = ""
}

variable "mysql_datadir" {
  default = "/var/lib/mysql"
}

variable "private_ssh_key" {
  default = ""
}

variable "sec_group" {
  type = "list"
}

variable "keypair" {
}

variable "flavor" {
  default = "e3standard.x3"
}

variable "external" {
  default = "false"
}

variable "network_name" {
}

variable "discovery_port" {
  default = "0"
}

variable "discovery" {
  default = "false"
}

variable "region" {
  default = "it-mil1"
}
