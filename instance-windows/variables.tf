variable "quantity" {
  default = 1
}

variable "name" {
  default = "Windows-IIS"
}

variable "sec_group" {
  type = "list"
}

variable "keypair" {
}

variable "image" {
  default = "Microsoft Windows Server 2016 Datacenter x64 WinRM"
}

variable "flavor" {
  default = "e3standard.x3"
}

variable "external" {
  default = "false"
}

variable "network_name" {
}

variable "region" {
  default = "it-mil1"
}

variable "password" {
  default = "P4ssw0rd!"
}
