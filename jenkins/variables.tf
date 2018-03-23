variable "master_flavor" {
   default = "e3standard.x2"
}

variable "region" {}

variable "keyname" {}

variable "network_name" {}

variable "image" {}

variable "tags" {
   default = {
    "server_group" = "JENKINS"
  }
}
