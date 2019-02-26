# ECS Module for create k8s Cluster
```
module "etcd" {
  source = "github.com/entercloudsuite/terraform-modules//openstack/etcd?ref=2.7"
  image = "ecs-etcd 1.0.1"
  region = "${var.region}"
  network_name = "${var.network_name}"
  flavor = "e3standard.x3"
  keyname = "${var.keypair_name}"
  custom_secgroups = ["${module.internal.sg_id}"]
}

module "kubernetes" {
  source = "github.com/entercloudsuite/terraform-modules//openstack/kubernetes-ha?ref=2.7"
  image = "ecs-kubernetes 1.13.2-1"
  region = "${var.region}"
  network_name = "${var.network_name}"
  master_flavor = "e3standard.x4"
  worker_flavor = "e3standard.x5"
  worker_count = 3
  keyname = "${var.keypair_name}"
  cloud_os_api_url = "https://api.entercloudsuite.com/v2.0"
  cloud_os_tenant_name = "cloud_os_tenant_name"
  cloud_os_username = "cloud_os_username"
  cloud_os_password = "cloud_os_password"
  cloud_os_region = "${var.region}"
  # Configure the variable below for restrict SSH access to Kubernetes master
  access-cidr = "1.1.1.1/32"
  # Configure the variable below for restrict Kubernetes API access
  api-access-cidr = "1.1.1.1/32"
  pod-network-cidr = "10.7.0.0/17"
  service-network-cidr = "10.7.128.0/17"
  custom_secgroups_master =["${module.internal.sg_id}"]
  custom_secgroups_workers = ["${module.internal.sg_id}"]
  etcd = "etcd-server"
  master_count = 3
  consul = "consul.service.automium.consul"
  consul_datacenter = "automium"
  consul_encrypt = "SSfewkvr15pczGbdPBgEbQ=="
  rancher_url = "127.0.0.1"
  rancher_cluster_token = "abc"
}
```
## Heketi
Deploy k8s cluster wit heketi

```
### New Terraform file
module "etcd" {
  source = "github.com/entercloudsuite/terraform-modules//openstack/etcd?ref=feature"
  image  = "ecs-etcd 1.0.2"
  region = "${var.region}"
  network_name  = "${var.network_name}"
  flavor = "e3standard.x3"
  keyname = "${var.keypair_name}"
  custom_secgroups = ["${module.allow_local.sg_id}"]
}

module "kubernetes" {
  
  master_count = 3
  worker_count = 3
  
 # heketi
  heketi_volume_size = "30"
  heketi_admin_password = "VerySecret"
  heketi_flavor = "e3standard.x3"
  heketi_count = 3

  
  source = "github.com/entercloudsuite/terraform-modules//openstack/kubernetes-ha?ref=master"
  image = "ecs-kubernetes-1.13.2-2-53"
  region = "${var.region}"
  network_name = "${var.network_name}"
  master_flavor = "e3standard.x4"
  worker_flavor = "e3standard.x5"
  keyname = "${var.keypair_name}"
  # Tenant Configuration Name
  cloud_os_api_url = "https://api.entercloudsuite.com/v2.0"
  cloud_os_tenant_name = "${data.vault_generic_secret.infra_secrets.data["os_tenant_name"]}"
  cloud_os_username = "${data.vault_generic_secret.infra_secrets.data["os_username"]}"
  cloud_os_password = "${data.vault_generic_secret.infra_secrets.data["os_password"]}"
  cloud_os_region    = "${var.region}"
  # Configure the variable below for restrict SSH access to Kubernetes master
  access-cidr = "212.29.132.138/32"
  # Configure the variable below for restrict Kubernetes API access
  api-access-cidr = "212.29.132.138/32"
  pod-network-cidr = "10.3.0.0/16"
  service-network-cidr = "10.255.0.0/16"
  custom_secgroups_master =["${module.allow_local.sg_id}","${module.bastion_mgmt_sg.sg_id}"]
  custom_secgroups_workers = ["${module.allow_local.sg_id}"]
  etcd = "etcd-server"
  consul = "${var.consul_global}"
  consul_datacenter = "${var.consul_global_datacenter}"
  consul_encrypt = "${var.consul_global_encrypt}"
}
```
## Heketi variables

| Variables Name | Description |
|---|---|---|
| heketi_flavor | Glusterfs server Flavor |
| heketi_namespace | in witch namespace install heketi and glusterfs pods |
| heketi_volume_size | Gluster-server Volumes size |
| heketi_glusterfs_container_version | gluster-server container version [Gluster DockerHub](https://hub.docker.com/r/gluster/gluster-centos) |
| heketi_volume_type | Gluster-server disk type ( hdd-standard hdd-top ssd-standard ssd-top) |

## How deploy PVC with heketi

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
 name: gluster1
 annotations:
   volume.beta.kubernetes.io/storage-class: gluster-heketi
spec:
 accessModes:
  - ReadWriteMany
 resources:
   requests:
     storage: 2Gi
```

Run test-deployment nginx with Heketi

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx-fronteend
          image: nginx
          volumeMounts:
          - mountPath: "/var/www/html"
            name: heketi-volume
      volumes:
        - name: heketi-volume
          persistentVolumeClaim:
            claimName: gluster2
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
 name: gluster2
 annotations:
   volume.beta.kubernetes.io/storage-class: gluster-heketi
spec:
 accessModes:
  - ReadWriteMany
 resources:
   requests:
     storage: 15Gi

```

## CleanUP heketi installation
1 set heketi node to 0
Run this command from master
```shell
kubectl delete -n heketi service heketi heketi-storage-endpoints
kubectl delete -n heketi deploy heketi
kubectl delete -n heketi all,service,jobs,deployment,secret --selector=deploy-heketi
kubectl delete -n heketi clusterrolebinding heketi-gluster-admin
kubectl delete -n heketi secret heketi-config-secret
kubectl delete -n heketi secret heketi-db-backup
kubectl delete -n heketi daemonset glusterfs
kubectl delete -n heketi sc gluster-heketi
```
