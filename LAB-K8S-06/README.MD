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

![configmap-example](./img/03-configmap.gif)

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
kubectl get deployment my-todo-deployment -o yaml > my-todo-deployment.yml
```

- Add a **volume** and **volumeMount** based on the following official documentation : Read | [Populate a Volume with data stored in a ConfigMap
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

#### Using ConfigMaps for multiple variables
We've seen how to use ConfigMaps directly mounted as volumes
- _white_check_mark: Let's go to the next step :
- We'd like to add some parameters to our NodeJS application to highlight our planet's assets (namespace name), 🔥 "Let's go Chewie!" 🔥 :

- Browse this link and look for the following information: https://swapi.dev/api/planets/
	- Planet name
	- Climate
	- Terrain
	- Population
	- Name of a resident of this planet

- As a first step, refer to the official documentation : Read | [Use ConfigMap-defined environment variables in Pod commands
](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#use-configmap-defined-environment-variables-in-pod-commands)

### Creating a new configMap (**solution**  [here](https://github.com/sokube/kubernetes-training/blob/master/LAB-K8S-06/solutions/03-simple-todo-configmap-env.yml)) : 

- name is configmap-env
- data with content (https://swapi.dev/api/planets/) :
``` shell
data:
  INFO_PLANET: "Tatooine"
  INFO_CLIMATE: "Arid"
  INFO_TERRAIN: "Desert"
  INFO_POPULATION: "200000"
  INFO_RESIDENT: "Beru Whitesun lars"
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

- Add the following environment variables (SW_*) :

	- SW_PLANET with key INFO_PLANET
	- SW_CLIMATE with key INFO_CLIMATE
	- SW_TERRAIN with key INFO_TERRAIN
	- SW_POPULATION with key INFO_POPULATION
	- SW_RESIDENT with key INFO_RESIDENT
	
- Let's apply our changes ! 

``` shell
    $ kubectl apply -f my-todo-deployment.yml
```

- Congratulations, that's it for the configMaps, let's move on to Secrets.
--- 
> **TIPS :**

| USAGES | EXAMPLES |
|--|--|
| --from-literal | sw.parameters.hero: 'Dark Vador!' |
| --from-file | sw.parameters.file: \|-  
| | sw.parameters.hero.1 = 'Dark Vador!' |
| | sw.parameters.hero.2 = 'Luke' |

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
