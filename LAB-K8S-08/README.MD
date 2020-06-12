# LAB-K8S-08: Persistence

**Description**: During this lab, we will re-architect our solution towards a stateless nature by using a database to store the content. In a second phase, we will get familiar with persistent volumes and persitent volume claims and see how they help us to achieve data persistence inside a Cluster.

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

#### Deploy a PostgreSQL Database + Service

- :white_check_mark: Read the [documentation](https://hub.docker.com/_/postgres) of the PostgreSQL container image to get familiar with the **requirements**, and especially the section around **environment variables**

- :white_check_mark: Write a **Secret** named **postgres-secret** that will define 3 variables necessary to create a working empty database:
``` shell
kubectl create secret generic postgres-secret \
--from-literal=POSTGRES_DB=swdb \
--from-literal=POSTGRES_USER=obiwankenobi \
--from-literal=POSTGRES_PASSWORD=masterjedi
```

- :white_check_mark: Create a deployment for the database, with the following requirements: (**solution** [here](./solutions/postgres-deployment.yml))
  - replica of **1 instance** only
  - The image to use is **postgres:10.4-alpine**
  - Container port **5432**
  - the environment variables will be defined from the secret postgres-secret using an all-keys injection (see [here](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#configure-all-key-value-pairs-in-a-secret-as-container-environment-variables))
 
- :white_check_mark: Expose the datase with a ClusterIP service named **postgres-service**, accessible on port **5432** as well (**solution** [here](./solutions/postgres-deployment-service.yml))

#### Deploy Todo List v3.0

In order to connect to an external database, the application now needs the follow environment variables:
>DB_USER: database user
DB_HOST: database server
DB_NAME: database name
DB_PORT: database server port
DB_PASSWORD: database user's password

- :white_check_mark: Use the previous deployment specification and update the image to version 3.0, use the secret **postgre-secret** keys to maps to these new environment variables (DB_USER, DB_PASSWORD, DB_NAME), as well as the **postgres service DNS name** and **port** for DB_HOST and DB_PORT. (**solution** [here](./solutions/simple-todo-pod-deployment-database.yml))

- :white_check_mark: Once working, scale the **replicas** to 2

- :white_check_mark: Can you confirm the application is now **stateless** ?

- :white_check_mark: Stop your application deployment and the database. Launch the database deployment. Launch the application deployment. What has happened?

---
## Persistent Volumes and Claims

They provide an abstraction between producers of storage space (admins on the cluster providing storage elements called persistent volumes) and consumers (applications requesting a storage volume through a claim).

- :white_check_mark: Read the documentation on [PersistentVolumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
- :white_check_mark: Try to create a persistent volume (pv.yml), what's happening?
- :white_check_mark: Why ?
- :white_check_mark: In which namespace is the persistent volume created ?

There can't be  more than 1 PVC per PV. The association to a PV depends on the PVC request capacity and the capacity of the first unbound PV, as well as the modes and access modes desired. The volume remains bound until the pvc is deleted, and the reclaim policy defines what happens upon release.

> The reclaim policy for a PersistentVolume tells the cluster what to do with the volume after it has been released of its claim. Currently, volumes can either be Retained, Recycled, or Deleted

The cluster admin has provisioned 20 persistent volumes of **capacity 50Mi**, with an access mode of **ReadWriteOnce** and  volume mode **Filesystem**. The storageclass to specify to claim these volumes is **small-nfs**.

- :white_check_mark: Create a persistent volume claim called **dbclaim** that will request one of these volumes. Set a capacity of **10Mi** in the claim. (**solution** [here](./pvc.yml))
- :white_check_mark: Verify your claim has a Bound status.

Now we will use our claim for our database.

- :white_check_mark:Read the [documention](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#claims-as-volumes) and Rewrite the deployment of the database to use the dbclaim as a volume. PostgreSQL stores the database data inside the **/var/lib/postgresql path** in the container.

- :white_check_mark: Verify the persistency of the data from your todo by inserting data and starting/stopping the deployments


----
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
- :white_check_mark: Rewrite your pvc specifying the **storageClassName: jelastic-dynamic-volume** and apply it
- :white_check_mark: Restart your database & application deployments
- :white_check_mark: What is the size of the claim ?

## Next lab
 - [LAB-K8S-09 - Network Policies](../LAB-K8S-09/README.MD)
