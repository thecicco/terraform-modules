variable "master_name" {
  default = "kubernetes-master"
}

variable "worker_name" {
  default = "kubernetes-workers"
}

variable "heketi_name" {
  default = "kubernetes-heketi"
}

variable "region" {
  default = "it-mil1"
}

variable "master_count" {
   default = "1"
}

variable "worker_count" {
   default = "2"
}

variable "heketi_count" {
   default = "3"
}

variable "master_flavor" {
   default = "e3standard.x2"
}

variable "worker_flavor" {
   default = "e3standard.x3"
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

variable "floating_ip_pool" {
   default = "PublicNetwork"
}

variable "access-cidr" {
   default = "0.0.0.0/0"
}

variable "api-access-cidr" {
   default = "127.0.0.1/32"
}

variable "pod-network-cidr" {
   default = "192.168.0.0/16"
}

variable "service-network-cidr" {
   default = "10.96.0.0/12"
}

variable "keyname" {}

variable "network_name" {}

variable "image" {}

variable "cloud_os_api_url" {}

variable "cloud_os_tenant_name" {}

variable "cloud_os_username" {}

variable "cloud_os_password" {}

variable "cloud_os_region" {}

variable "custom_secgroups_master" {
   default = []
}

variable "custom_secgroups_workers" {
   default = []
}

variable "etcd" {
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

variable "rancher_url" {
  default = "consul.service.automium.consul"
}

variable "rancher_cluster_token" {
  default = ""
}
