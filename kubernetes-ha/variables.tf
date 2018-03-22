variable "region" {
  default = "it-mil1"
}

variable "worker_count" { 
   default = "2"
}

variable "master_flavor" {
   default = "e3standard.x2"
}

variable "worker_flavor" {
   default = "e3standard.x3"
}

variable "floating_ip_pool" {
   default = "PublicNetwork"
}

variable "kube-token" {
   default = "9e5124.a44b452adf9f331e"
}

variable "access-cidr" {
   default = "0.0.0.0/0"
}

variable "keyname" {}

variable "network_name" {}

variable "image" {}
