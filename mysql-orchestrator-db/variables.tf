variable "quantity" {
  default = 1
}

variable "name" {
  default = "mysql"
}

variable "mysql_port" {
  default = "3306"
}

variable "mysql_master_port" {
  default = "3307"
}

variable "mysql_slaves_port" {
  default = "3308"
}

variable "mysql_datadir" {
  default = "/var/lib/mysql-orchestrator"
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
  default = "80"
}

variable "consul" {
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
  default = "admin"
}

variable "orchestrator_password" {
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
  default = "true"
}

variable "region" {
  default = "it-mil1"
}

variable "pmm_server" {
  default = ""
}

variable "pmm_user" {
  default = "admin"
}

variable "pmm_password" {
  default = ""
}

variable "os_api" {
  default = ""
}

variable "os_region" {
  default = ""
}

variable "os_project" {
  default = ""
}

variable "os_project_id" {
  default = ""
}

variable "os_user" {
  default = ""
}

variable "os_password" {
  default = ""
}

variable "influxdb_url" {
  default = ""
}

variable "influxdb_port" {
  default = ""
}

variable "influxdb_databasename" {
  default = ""
}

variable "influxdb_username" {
  default = ""
}

variable "influxdb_password" {
  default = ""
}

variable "restic_forget_time_day" {
  default = "7"
}

variable "restic_start_backup_time" {
  default = "*-*-* 01:00:00"
}
