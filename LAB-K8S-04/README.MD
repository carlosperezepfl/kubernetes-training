# LAB-K8S-04: Services

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

---

- :white_check_mark: Create a **Service** inside your namespace that will match the following specifications (solution [here](./solutions/)) :
> name: **my-app-example-2**
> selector: label **app** is **my-app-example**
> type: **ClusterIP**
> port: **80**
> targetPort: **80**
  
> :bulb: **TIPS:** The **YAML** is used for configuration files :
> Don't forget that .yaml files indentation is exclusively using  **spaces** and not **tabulations**.

| TYPES | USAGES |
|--|--|
| ClusterIP | Expose the service on an internal ip (default type) |
| NodePort | Expose the service on the IP of each node |
| LoadBalancing | The process of efficiently distributing network traffic between multiple services |

---
  
- :white_check_mark: Deploy this newly created file :
  ``` shell
  kubectl create -f service-example.yml
  ```

- :white_check_mark: Let's make sure it was created :
  ```shell
  kubectl get services
  ``` 
Congratulations, but it's not over yet. That would have been too simple. It turns out that in a hurry, we made a mistake.
       
``` shell
kubectl describe service my-app-example-2 
```

> Name:              my-app-example-2
Namespace:         tatooine
Labels:            app=my-app-example-2
Annotations:       <none>
Selector:          app=my-app-example
Type:              ClusterIP
IP:                10.244.58.32
Port:              http  80/TCP
TargetPort:        80/TCP
Endpoints:         <none>
Session Affinity:  None
Events:            <none>

- :white_check_mark: Can you spot what's wrong with our service ?

- :white_check_mark: Correct the **selector** and  deploy this service :
  ``` shell
  kubectl create -f service.yaml
  ```

- :white_check_mark: Or it is also possible to expose your pod in this way :
  ``` shell
  kubectl expose pod my-app-example-2 --port=80
  ```

Now let's test a bit this service and its backend application

- :white_check_mark: Deploy a pod within the cluster that will help us to perform some tests
  ```
  kubectl apply -f debug-pod.yml
  ```

- :white_check_mark: Enter into an interactive shell of this pod
  ``` shell
  kubectl exec debug -it /bin/sh
  ```
- :white_check_mark: Read the documentation on the **DNS names** for a service:
https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#services

- :white_check_mark: From within the **debug** pod and using curl, find 5 different ways to display the root page of the pod in the backend


:cocktail: **Congratulations, you've been deploying and testing a service** :cocktail: 

---
## Tips
>:bulb: **Tips:** Save your file in vim with :
>
>:wq
>

>:bulb: **Tips:** To enable line numbers on the vim editor, just enter :
>
>:set nu + enter
>

>:bulb: **Tips:** While debugging services, the most common mistake is the selector. Look at the endpoints in the describe service first to see if a backend has been associated.
>

---
 ## Next lab 
 
 - [LAB-K8S-05 - Deployments](../LAB-K8S-05/README.MD)
