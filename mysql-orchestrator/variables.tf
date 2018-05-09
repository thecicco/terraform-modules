variable "quantity" {
}

variable "bootstrap" {
  default = "false"
}

variable "orchestrator_quantity" {
  default = 3
}

variable "orchestrator_ip" {
}

variable "orchestrator_subnet" {
  default = ""
}

variable "orchestrator_virtual_router_id" {
}

variable "name" {
}

variable "mysql_flavor" {
  default = "e3standard.x3"
}

variable "mysql_ip" {
}

variable "mysql_subnet" {
}

variable "mysql_port" {
  default = "3306"
}

variable "mysql_virtual_router_id" {
}

variable "mysql_volume_size" { 
}

variable "mysql_volume_type" {
  default = "Top"
}

variable "orchestrator_port" {
  default = "80"
}

variable "orchestrator_raft_default_port" {
  default = "10008"
}

variable "consul" {
}

variable "consul_port" {
  default = "8500"
}

variable "consul_datacenter" {
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
}

variable "orchestrator_user" {
  default = "orchestrator"
}

variable "orchestrator_password" {
}

variable "mysql_datadir" {
  default = "/var/lib/mysql-orchestrator"
}

variable "private_ssh_key" {
}

variable "external" {
  default = "false"
}

variable "keypair" {
}

variable "network_name" {
}

variable "sec_group" {
  type = "list"
}

variable "region" {
  default = "it-mil1"
}
