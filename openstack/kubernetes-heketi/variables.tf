variable "heketi_name" {
  default = "kubernetes-heketi"
}

variable "region" {
  default = "it-mil1"
}

variable "heketi_count" {
   default = "3"
}

variable "heketi_flavor" {
   default = "e3standard.x3"
}

variable "heketi_namespace" {
   default = "heketi"
}

variable "heketi_volume_size" {
}

variable "heketi_glusterfs_container_version" {
   default = "gluster4u0_centos7"
}

variable "heketi_heketi_container_version" {
   default = "8"
}

variable "heketi_volume_type" {
  default = "Top"
}

variable "heketi_admin_password" {
}

variable "heketi_storageclass_arbiter" {
   default = "True"
}

# in whitch cluster you want add hekti
variable "kubernetes_master_name" {
}

# Use default Heketi values https://github.com/heketi/heketi/blob/master/docs/admin/arbiter.md
variable "heketi_storageclass_arbiter_average_file_size" {
   default = "64"
}

variable "service-network-cidr" {
   default = "10.96.0.0/12"
}

variable "master-ip" {
}

variable "keyname" {}

variable "network_name" {}

variable "image" {}

variable "cloud_os_api_url" {}

variable "cloud_os_tenant_name" {}

variable "cloud_os_username" {}

variable "cloud_os_password" {}

variable "cloud_os_region" {}


variable "custom_secgroups_heketi" {
   default = []
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
