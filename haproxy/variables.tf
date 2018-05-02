variable "flavor" {
   default = "e3standard.x1"
}

variable "region" {}

variable "keyname" {}

variable "network_name" {}

variable "image" {}

variable "external" {
   default = "true"
}

variable "quantity" {
   default = 1
}

variable "tags" {
   default = {
    "server_group" = "HAPROXY"
  }
}
