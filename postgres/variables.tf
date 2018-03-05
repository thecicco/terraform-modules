variable "flavor" {
   default = "e3standard.x2"
}

variable "region" {}

variable "keyname" {}

variable "network_name" {}

variable "image" {}

variable "image_slave" {
    default = "${var.image}"
}

variable "slave_count" {
    default = 0
}
