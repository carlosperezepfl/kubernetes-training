

# LAB-K8S-07: Persistence

**Description**: 

**Duration**: 60m

## Goals
*List the goals using bullet point per goal, eg:
At the end of this lab, each participant will have:*
*- a working local environment to perform the k8s labs on a remote k8s cluster, inside its own namespace.*
*- a working local environment to perform the k8s labs on a remote k8s cluster, inside its own namespace.*

## Prerequisites
 - [LAB-K8S-01 - Basic Setup](../LAB-K8S-01/README.MD)
 - [LAB-K8S-03 - PODs](../LAB-K8S-03/README.MD)
 - [LAB-K8S-05 - Deployment](../LAB-K8S-03/README.MD)

*List prerequisites using bullet point per goal, eg:*
*- Each participant has received personal pre-generated kubectl config file by email and the name of the corresponding **namespace***
*- A laptop or station with Windows, MacOS or Linux and a working Internet connection are necessary.*

----

## Stateless Todo

- Setup a PostgreSQL database server
- Deployment
- Service
- Secrets
- Kill the DB -> no data: Persistence

## Persistent Volumes

small-nfs storage class

## Persistent Volume Claims

verify the storage disk space on /var/lib/.... with a command

## Storage Classes

A more elegant and efficient way than having cluster administrators pre-creating a set of **PersistentVolumes** for the claims to come is to use **StorageClasses**, which allows for the dynamic provisioning of the volumes behind a claim.

In our target cluster, we have a storage class called jelastic-dynamic-volume:

``` shell
kubectl describe sc jelastic-dynamic-volume

Name:                  jelastic-dynamic-volume
IsDefaultClass:        Yes
Annotations:           storageclass.kubernetes.io/is-default-class=true
Provisioner:           cluster.local/nfs-client-provisioner
Parameters:            archiveOnDelete=true
AllowVolumeExpansion:  True
MountOptions:
  soft
  proto=tcp
ReclaimPolicy:      Delete
VolumeBindingMode:  Immediate
Events:             <none>
```

This storage class is based on the **nfs client provisioner** and provides **immediate binding** of the pvc and the pv's created. Upon unbinding, the underlying volume is deleted.

- :white_check_mark: Stop your deployment, and delete your previous **persistent volume claim**
- :white_check_mark: Rewrite your pvc specifying the **storageClassName: jelastic-dynamic-volume**
- :white_check_mark: Restart your deployment and verify your database gets created
