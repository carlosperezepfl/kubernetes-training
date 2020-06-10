# LAB-K8S-04: Services

⚠️ REVOIR CONTENU (pas convaincu et pas d'idées sur ce LAB) + RELECTURE A FAIRE + TESTS A FAIRE ⚠️

**Description**: In this lab, participants will learn how to use services, get to know their different types and learn about debugging

**Duration**: *±30m*

## Goals

At the end of this lab, each participant will have:*
- Created and edited a Service Object.


## Prerequisites
 - [LAB-K8S-01 - Basic Setup](../LAB-K8S-01/README.MD)
 - [LAB-K8S-03 - PODs](../LAB-K8S-03/README.MD)

---
## Overview

![Arch](./img/00-service.png)

## Service

![Service example](./img/01-service.gif)
### Creating a Service :

- Open https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/#creating-a-service and read the example Service specification.

>:bulb: **Tips:** Save your file with :
```
:wq
```

>:bulb: **Tips:** To enable line numbers on the vim editor, just enter :

```
:set nu + enter
```
---

- :white_check_mark: Create a **Service** inside your namespace that will match the following specifications (solution [here](./solutions/)) :
> name: **service-my-todo-list**
> selector: label **app** is **my-todo-list**
> type: **ClusterIP**
> port: **80**
> targetPort: **8080**
  
> :bulb: **TIPS:** The **YAML** is used for configuration files :
> Don't forget that .yaml files indentation is exclusively using  **spaces** and not **tabulations**.
---
| TYPES | USAGES |
|--|--|
| ClusterIP | Expose the service on an internal ip (default type) |
| NodePort | Expose the service on the IP of each node |
| LoadBalancing | The process of efficiently distributing network traffic between multiple services |

---
  
- Deploy this newly created file :
```
    $ kubectl create -f service-my-todo-list.yml
```
- Let's make sure it was created :
```
    $ kubectl get services
``` 
- Congratulations, but it's not over yet. That would have been too simple. It turns out that in a hurry, we deployed a service that didn't seem to work... I'll let you see that.
       
```
$ cat /LAB-K8S-04-services/service-with-bugs.yml
```

-  It's a trap... A real storm came through here... Correct all these mistakes!
    
``` shell
$ vim service.yml
```

``` shell
$ mv service-with-bugs.yml service.yml
```

---

-  **Well Done !** It's time to deploy this service :
    

```
kubectl create -f service.yaml
```

-   Let's go see if everything went well :
    
```
kubectl get services
```

![Get service](./img/04-service.png)

 ## Next lab 
 
 - [LAB-K8S-05 - Deployments](../LAB-K8S-05/README.MD)
