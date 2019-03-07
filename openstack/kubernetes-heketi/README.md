# Heketi
## Requisites

**K8s Cluster**
```
module "kubernetes-heketi" {
 
  heketi_volume_size = "30"
  heketi_admin_password = "VerySecret"
  heketi_flavor = "e3standard.x3"
  heketi_count = 3
  heketi_glusterfs_container_version = "gluster3u12_centos7"
  custom_secgroups_heketi = ["${module.allow_local.sg_id}"]
  kubernetes_master_name = "kubernetes-master"
  service-network-cidr = "service_network"
 
  master-ip = "ip_yourK8s_cluster"

  source         = "github.com/automium/terraform-modules//openstack/kubernetes-heketi?ref=master"
  image         = "ecs-kubernetes-1.13.2-2-53"
  region         = "${var.region}"
  network_name        = "${var.network_name}"
  keyname         = "${var.keypair_name}"

 # Tenant Configuration Name
  cloud_os_api_url    = "https://api.entercloudsuite.com/v2.0"
  cloud_os_tenant_name    = "${data.vault_generic_secret.infra_secrets.data["os_tenant_name"]}"
  cloud_os_username    = "${data.vault_generic_secret.infra_secrets.data["os_username"]}"
  cloud_os_password    = "${data.vault_generic_secret.infra_secrets.data["os_password"]}"
  cloud_os_region    = "${var.region}"

 # Tenant Configuration Name
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

## Deploy PVC Arbiter in heketi wit avverage filesize 1MiB

```
apiVersion: storage.k8s.io/v1beta1
kind: StorageClass
metadata:
  name: gluster-heketi-big-file
provisioner: kubernetes.io/glusterfs
parameters:
  resturl: "http://10.255.66.76:8080"
  volumenameprefix: test
  volumeoptions: "user.heketi.arbiter true,user.heketi.average-file-size 1024"
allowVolumeExpansion: true
```

## Run simple deployment nginx

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
## Heketi DOC

### Variables
|Variables Name| Descriptions|
| --- | --- |
|heketi_storageclass_arbiter | Default Heketi stogrageclass will deploy wit arbiter by default if true |
|heketi_storageclass_arbiter_average_file_size| Average file size residient in glusterfs storage, used for calculate arbiter volume size check Doc for more information. https://github.com/heketi/heketi/blob/master/docs/admin/arbiter.md |

## CleanUP heketi installation
1 set heketi node to 0
Execs this command from master
```
kubectl delete -n heketi service heketi heketi-storage-endpoints
kubectl delete -n heketi deploy heketi
kubectl delete -n heketi all, service, jobs, deployment, secret --selector=deploy-heketi
kubectl delete -n heketi clusterrolebinding heketi-gluster-admin
kubectl delete -n heketi secret heketi-config-secret
kubectl delete -n heketi secret heketi-db-backup
kubectl delete -n heketi daemonset glusterfs
kubectl delete -n heketi sc gluster-heketi
```
