variable "quantity" {
  default = 1
}

variable "name" {
  default = "mysql"
}

variable "mysql_ip" {
  default = ""
}

variable "mysql_subnet" {
  default = ""
}

variable "mysql_port" {
  default = "3306"
}

variable "mysql_datadir" {
  default = "/var/lib/mysql-orchestrator"
}

variable "mysql_virtual_router_id" {
  default = ""
}

variable "mysql_volume_size" {
}

variable "mysql_volume_type" {
  default = "Top"
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
