# LAB-K8S-08: Persistence

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
 - [LAB-K8S-05 - Deployment](../LAB-K8S-05/README.MD)

----

## A stateless todo list

In the [LAB-K8S-05 - Deployment](../LAB-K8S-05/README.MD), we have seen one important limitation of our architecture for the simple todo list, that prevents us to use gracefully the scaling and services features of the kubernetes cluster: the application is not **stateless**.

Our development team has been hard at work to completely rewrite the backend part of the application and use an external PostgreSQL database to store its state outside of the application, and has come up with version 3.0 of the todo list. 

For this task, we gonna use **Secrets** and **Deployments** to deploy this database into our namespace.

#### Deploy a PostgreSQL Database

- :white_check_mark: Read the [documentation](https://hub.docker.com/_/postgres) of the PostgreSQL container image to get familiar with the **requirements**, and especially the section around **environment variables**
- :white_check_mark: Write a **Secret** named **postgres-secret** that will define 3 variables necessary to create a working empty database:
``` shell
kubectl create secret generic postgres-secret \
--from-literal=database-password=kenobi \
--from-literal=database-user=obiwan \
--from-literal=database-name=swdb
```
- :white_check_mark: Create a deployment for the database, with the following requirements: (**solution** [here](./solutions/postgres-deployment.yml))
  - replica of **1 instance** only
  - The image to use is **postgres:10.4-alpine**
  - Container port **5432**
  - the environment variables will be defined from the secret postgres-secret using the following mapping:
    - POSTGRES_DATABASE: postgres-secret/database-name
    - POSTGRES_USER: postgres-secret/database-user
    - POSTGRES_PASSWORD: postgres-secret/database-password
 
- :white_check_mark: Expose the datase with a ClusterIP service named **postgres-service**, accessible on port 5432 as well (**solution** [here](./solutions/postgres-deployment-service.yml))

#### Deploy Todo List v3.0


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
