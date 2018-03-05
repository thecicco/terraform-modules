variable "flavor" {
   default = "e3standard.x2"
}

variable "region" {}

variable "keyname" {}

variable "network_name" {}

variable "image" {}

variable "image_slave" {
    default = "GNU/Linux Ubuntu Server 16.04 Xenial Xerus x64"
}

variable "slave_count" {
    default = 0
}
