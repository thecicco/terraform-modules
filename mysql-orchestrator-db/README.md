# ECS Module for create Mysql

## Rebuild a broken node
```
NODE_NUMBER=0
MODULE_LOCAL_NAME=mysql-orchestrator
./terraform taint -module=${MODULE_LOCAL_NAME}.mysql 'consul_catalog_entry.service.${NODE_NUMBER}'
./terraform taint -module=${MODULE_LOCAL_NAME}.mysql 'openstack_compute_instance_v2.cluster.${NODE_NUMBER}'
./terraform taint -module=${MODULE_LOCAL_NAME}.mysql 'openstack_networking_port_v2.port_local.${NODE_NUMBER}'
./terraform taint -module=${MODULE_LOCAL_NAME}.mysql-volume 'openstack_blockstorage_volume_v2.volume.${NODE_NUMBER}'
./terraform taint -module=${MODULE_LOCAL_NAME}.mysql-volume 'openstack_compute_volume_attach_v2.va.${NODE_NUMBER}'
```
if you have a floatingip for each host i need also
```
./terraform taint -module=${MODULE_LOCAL_NAME}.mysql 'openstack_compute_floatingip_associate_v2.external_ip.${NODE_NUMBER}'
./terraform taint -module=${MODULE_LOCAL_NAME}.mysql 'openstack_networking_floatingip_v2.ips.${NODE_NUMBER}'
```
and apply the changes
```
./terrafrom apply
```
