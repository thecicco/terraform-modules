variable "quantity" {
  default = 1
}

variable "name" {
  default = "orchestrator"
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
}

variable "consul_encrypt" {
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
  default = "admin"
}

variable "orchestrator_password" {
  default = ""
}

variable "orchestrator_authentication_method" {
  default = "basic"
}

variable "orchestrator_http_auth_user" {
  default = "admin"
}

variable "orchestrator_http_auth_password" {
  default = ""
}

variable "orchestrator_raft_enabled" {
  default = "true"
}

variable "orchestrator_raft_data_dir" {
  default = "/var/lib/orchestrator"
}

variable "orchestrator_raft_default_port" {
  default = "10008"
}

variable "orchestrator_raft_nodes" {
  default = "[]"
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
  default = "true"
}

variable "region" {
  default = "it-mil1"
}
