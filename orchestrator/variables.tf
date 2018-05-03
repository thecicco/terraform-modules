variable "quantity" {
  default = 1
}

variable "name" {
  default = "orchestrator"
}

variable "orchestrator_vip" {
  default = "false"
}

variable "orchestrator_ip" {
  default = "1.1.1.1"
}

variable "orchestrator_subnet" {
  default = ""
}

variable "orchestrator_virtual_router_id" {
  default = ""
}

variable "orchestrator_port" {
  default = "80"
}

variable "orchestrator_service_port" {
  default = "3000"
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

variable "mysql_port" {
  default = "3306"
}

variable "orchestrator_user" {
  default = ""
}

variable "orchestrator_password" {
  default = ""
}

variable "orchestrator_raft_enabled" {
  default = "false"
}

variable "orchestrator_raft_data_dir" {
  default = ""
}

variable "orchestrator_raft_default_port" {
  default = "10008"
}

variable "orchestrator_raft_nodes" {
  default = "[]"
}

variable "discovery_port" {
  default = "0"
}

variable "mysql_datadir" {
  default = "/var/lib/mysql"
}

variable "sec_group" {
  type = "list"
}

variable "keypair" {
}

variable "flavor" {
  default = "e3standard.x2"
}

variable "external" {
  default = "false"
}

variable "network_name" {
}

variable "discovery" {
  default = "false"
}

variable "region" {
  default = "it-mil1"
}
