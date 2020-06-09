# LAB-K8S-06: ConfigMaps

**Description**: In this lab, participants will learn how to use ConfigMap, as a first step, a configMap (css file) that will overwrite the existing files.

**Duration**: ±40m

## Goals
At the end of this laboratory, each participant will be able to set up a configMap and its volume to simply modify configurations such as for example a virtual host, an application configuration file etc...

## Prerequisites
 - [LAB-K8S-01 - Basic Setup](../LAB-K8S-01/README.MD)
 - [LAB-K8S-03 - PODs](../LAB-K8S-03/README.MD)
 - [LAB-K8S-04 - Services](../LAB-K8S-04/README.MD)
 - [LAB-K8S-05 - Deployments](../LAB-K8S-05/README.MD)

---
## ConfigMap
When you start developping/integrating an application, what a pleasure to be able to modify parameters in one or more configuration files without having to completely rebuild an image.

A traditional approach is to decorrelate application code from its configuration. (key/value)

And that's where **configMaps** come in.

>**WARN :** A configMap must not contain sensitive data.

 - Read | [Concepts - ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)
 
It's time to create our first configMap :

### Creating a ConfigMap :

The goal here will be to set up a configmap that will feed a css stylesheet that will override the style of your future application.

- Open [https://kubernetes.io/docs/concepts/configuration/configmap/#configmaps-and-pods](https://kubernetes.io/docs/concepts/configuration/configmap/#configmaps-and-pods) and read the example configMap specification.

- Create a  **configMap**  inside your namespace that will match the following specifications (**solution**  [here](https://github.com/sokube/kubernetes-training/blob/master/LAB-K8S-06/solutions/01-simple-todo-configmap.yml)) :
- Specifications : 

	- name is configmap-css-additionnal
	- data with content (You can change it in *style* later) :

![content-configmap](./img/02-configmap.png)

- Deploy this newly created file : 
``` shell
    $ kubectl create -f configmap-css-additional.yml
```
- Let's make sure it's been created :
``` shell
    $ kubectl get configmaps
```    
- Congratulations, now we'll have to make sure to declare our configmap volume in our deployment : 

 - Retrieve the deployment you have used in the past :
``` shell
    $ kubectl get deployment my-todo-deployment -o yaml > my-todo-deployment.yml
```

- Add a volume and volumeMount based on the following official documentation : Read | [Populate a Volume with data stored in a ConfigMap
](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#populate-a-volume-with-data-stored-in-a-configmap)
> mountPath must match : /usr/src/app/static/css/css-additional (**solution**  [here](https://github.com/sokube/kubernetes-training/blob/master/LAB-K8S-06/solutions/02-simple-todo-pod-deployment-configmap.yml)) :

- Once finished, apply the new configuration of your deployment :

``` shell
    $ kubectl apply -f my-todo-deployment.yml
```
- A little routine check :

``` shell
    $ kubectl get deployments -o wide -w
```

``` shell
    $ kubectl get pods -o wide -w
```

- Let's go to the next step :
- We would like to add two parameters to our NodeJS application to highlight our favorite Star wars character and movie. 🔥 "Let's go Chewie !" 🔥 :

- As a first step, refer to the official documentation : Read | [Use ConfigMap-defined environment variables in Pod commands
](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#use-configmap-defined-environment-variables-in-pod-commands)

### Creating a new configMap (**solution**  [here](https://github.com/sokube/kubernetes-training/blob/master/LAB-K8S-06/solutions/03-simple-todo-configmap-env.yml)) : 

- name is configmap-env
- data with content :
``` shell
data:
  FAVORITE_SW_HERO: "Dark Vador"
  FAVORITE_SW_MOVIE: "..."
```

- Deploy this newly created file : 
``` shell
    $ kubectl create -f configmap-env.yml
```

- Let's make sure it's been created :
``` shell
    $ kubectl get configmaps
```

### Creating a new deployment (**solution**  [here](https://github.com/sokube/kubernetes-training/blob/master/LAB-K8S-06/solutions/04-simple-todo-pod-deployment-configmap-env.yml)) :

 - Retrieve the deployment you have used in the past :
``` shell
    $ kubectl get deployment my-todo-deployment -o yaml > my-todo-deployment.yml
```

- Add the following two environment variables :

	- SW_HERO with key FAVORITE_SW_HERO
	- SW_MOVIE with keu FAVORITE_SW_MOVIE
	
- Let's apply our changes ! 

``` shell
    $ kubectl apply -f my-todo-deployment.yml
```

- Congratulations, that's it for the configMaps, let's move on to Secrets.
--- 

| CHARACTER | SHORTCUT | USAGE |
|--|--|--|
| > | MAJ + < | Single-line format |
| \| | ALT-G + 6 | Multi-line format |

Examples : 

    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: example
      labels:
        app: example
    data:
      example-single-line.yml: > Single-line example
	
    ---
    
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: example-multi-line
      labels:
        app: example-multi-line
    data:
      example-multi-line.yml: | 
	  key1:
	    value1: 'example1'
	  key2:
	    value2: 'example1'
	  
---
