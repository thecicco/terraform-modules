variable "manager_flavor" {
   default = "e3standard.x2"
}

variable "worker_flavor" {
   default = "e3standard.x4"
}

variable "manager_count" { 
   default = 1
}

variable "worker_count" { 
   default = 0
}

variable "join_token" {}

variable "manager_ip" {}

variable "region" {}

variable "keyname" {}

variable "network_name" {}

variable "image" {}

variable "tags_manager" = {
   default = {
    "icinga2_client" = ""
    "swarm_manager" = ""
    "server_group" = "SWARM"
  }
}

variable "tags_worker" = {
   default = {
    "icinga2_client" = ""
    "swarm_worker" = ""
    "server_group" = "SWARM"
  }
}
