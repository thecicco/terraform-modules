variable "region" {}
variable "name" {}
variable "dns1" {
  default = "8.8.8.8"
}
variable "dns2" {
  default = "8.8.4.4"
}

variable "internal-network-cidr" {
    default = "10.2.0.0/16"
}

variable "router_id" {
  default = ""
}
