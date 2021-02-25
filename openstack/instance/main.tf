terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}

data "openstack_networking_network_v2" "instance_network" {
  region = var.region
  name = var.network_name
}

output "instance" {
    value = openstack_compute_instance_v2.cluster.*.id
}

output "instance-address" {
    value = openstack_compute_instance_v2.cluster.*.access_ip_v4
}

output "public-instance-address" {
    value = openstack_networking_floatingip_v2.ips.*.address
}

output "quantity" {
    value = var.quantity
}

resource "openstack_networking_floatingip_v2" "ips" {
  region = var.region
  count = var.external ? var.quantity : 0
  pool = var.floating_ip_pool
}

resource "openstack_compute_servergroup_v2" "clusterSG" {
  count = var.quantity > 0 ? 1 : 0
  region = var.region
  name     = var.name
  policies = [var.server_group_policy]
}

resource "openstack_compute_floatingip_associate_v2" "external_ip" {
  region = var.region
  count = var.external ? var.quantity : 0
  floating_ip = openstack_networking_floatingip_v2.ips.*.address[count.index]
  instance_id = openstack_compute_instance_v2.cluster.*.id[count.index]
}

resource "openstack_networking_port_v2" "port_local" {
  count = var.quantity
  name = "${var.name}-${count.index}"
  network_id = data.openstack_networking_network_v2.instance_network.id
  admin_state_up = "true"
  region = var.region
  security_group_ids = concat(var.sec_group,list(element(var.sec_group_per_instance,count.index)))

  allowed_address_pairs {
    ip_address = var.allowed_address_pairs
  }

  lifecycle {
    ignore_changes = all
  }
}

data "external" "image_sync" {
  program = [
    "/bin/bash",
    "-c",
    <<EOF
export OS_REGION=var.region
export OS_AUTH_URL=var.auth_url
export OS_TENANT_NAME=var.tenant_name
export OS_USERNAME=var.user_name
export OS_PASSWORD=var.password
export IMAGE=var.image
export IMAGE_UUID=var.image_uuid
bash ${path.module}/image_sync.sh
EOF
  ]
}

output "image_sync_message" {
  value = data.external.image_sync.result.output
}

resource "openstack_compute_instance_v2" "cluster" {
  region = var.region
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]
  count = var.quantity
  flavor_name = var.flavor
  name = "${var.name}-${count.index}"
  image_id = var.image_uuid == "" ? data.external.image_sync.result.image_uuid : var.image_uuid
  key_pair = var.keypair

  scheduler_hints {
    group = openstack_compute_servergroup_v2.clusterSG[count.index].id
  }

  network {
    uuid = data.openstack_networking_network_v2.instance_network.id
    port = openstack_networking_port_v2.port_local.*.id[count.index]
  }

  lifecycle {
    ignore_changes = all
  }

  stop_before_destroy = "true"
  metadata = var.tags
  user_data = element(var.userdata,count.index)
}

resource "consul_node" "node_local" {
  count = var.discovery ? var.quantity : 0
  name = "${var.name}-${count.index}"
  address = "openstack_compute_instance_v2.cluster.*.access_ip_v4[count.index]"
}

resource "consul_service" "service_local" {
  count = var.discovery ? var.quantity : 0
  name = var.name
  node = consul_node.node_local[count.index].name
  port = var.discovery_port
  tags = [count.index]
}

resource "consul_node" "node_external" {
  count = (var.discovery) && (var.external) ? var.quantity : 0
  name = "${var.name}-${count.index}"
  address = openstack_compute_instance_v2.cluster.*.access_ip_v4[count.index]
}


resource "consul_service" "service_external" {
  count = (var.discovery) && (var.external) ? var.quantity : 0
  name = var.name
  node = consul_node.node_external[count.index].name
  port    = var.discovery_port
  tags    = [count.index]
}