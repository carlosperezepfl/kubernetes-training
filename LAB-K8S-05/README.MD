

# LAB-K8S-05: Deployment

**Description**: For this lab, the participants will learn how to use Deployments inside Kubernetes, and will practise roll-outs of new versions as well as roll-backs.

**Duration**: ±45m

## Goals
At the end of this lab, each participant will be able to roll-out and roll-back a new version of an application with a Deployment object both in imperative and declarative ways.

## Prerequisites
 - [LAB-K8S-01 - Basic Setup](../LAB-K8S-01/README.MD)

----

## Trouble with the force
- :white_check_mark: Look at your application using your landing zone, eg: https://sokube-k8s-training.hidora.com/tatooine.
- :white_check_mark: Is your application still running ?
- :white_check_mark: Can you diagnose what's happening ? (remember the events section in the POD's description)
- :white_check_mark: Kill the application POD

---
## Liveness Probe
Our application is still in early development and some areas are still buggy. In particular we know a section is potentially introducing endless loops. Kubernetes has a built-in mechanism to decide upon POD status (and restart mechanisms) for non responsive applications : **liveness probes**.

> The kubelet uses liveness probes to know when to restart a container. For example, liveness probes could catch a deadlock, where an application is running, but unable to make progress. Restarting a container in such a state can help to make the application more available despite bugs.

- :white_check_mark: Read [Configure Liveness, Readiness and Startup Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-a-liveness-http-request)

In a :fire: **hurry** :fire:  and while the issue is investigated, our application developers have introduced a **new HTTP REST** endpoint (available at **/health**) in the application to allow for an external probe.

- :white_check_mark: Update the image  of your POD to **sokubedocker/simple-todo:1.1**, using the **declarative** method (remember we used a YAML in [LAB-K8S-02](../LAB-K8S-02/README.MD)). **Solution** [here](./solutions/simple-todo-pod-emergency.yaml).

- :white_check_mark: Try the new application new REST service with your landing zone's URL, eg: https://sokube-k8s-training.hidora.com/tatooine/api/v1/health, what is it answering ?

Let's use what we've learned about liveness probes and implement one leveraging this new REST endpoint.

- :white_check_mark: Complement the previous POD declaration with the liveness probe specs below and apply it. Try your new application. **Solution** [here](./solutions/simple-todo-pod-liveness.yaml).
  - The check will has to be run periodically **each 5s**
  - The HTTP url to use is **/health** on **port 8080**
  - A request taking more than  **1s** means our application can be considered non-responsive, and must be restarted
  - We want to avoid deciding liveness while the application is starting, so we'll give the application a **grace period of 5s** before starting the probe

Is our liveness probe solving the problem ? The instructor will remotely trigger your pod entering in an endless loop.

- :white_check_mark: Watch your pod:
``` shell
watch kubectl get pod simple-todo-pod --namespace=tatooine
``` 
- :white_check_mark: Is it **restarting** ?
- :white_check_mark: Check your application with your landing zone URL, eg: https://sokube-k8s-training.hidora.com/tatooine/. Is it **available** ?

---

## Using Deployments
 
Deployments are the controlled way to express desired states of your applications and let kubernetes system handle the changes to bring to the actual state. Deployments are prefereable 

First, let's **cleanup** our environment:
- :white_check_mark: Kill the previously created POD. 

#### Creating a Deployment

:white_check_mark: Open https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#creating-a-deployment and read the example deployment specification.

:white_check_mark: Create a **deployment** inside your namespace that will match the following specifications (**solution** [here](./solutions/simple-todo-pod-deployment.yaml)) :

  - **name** is my-todo-deployment
  - 1 replica of a POD that has the label **app:simple-todo**
  - POD's specification remains the same:
    - **image** to use for the POD's container is sokubedocker/simple-todo:1.1
    - **port** is 8080
    - **labels** must have the key:value pair app:simple-todo
    - **liveness** probe must be defined

:white_check_mark: Use the **kubectl create** command to create your **deployment**.
``` shell
kubectl create -f <filename>
```

:white_check_mark: List the **deployments** in your namespace
``` shell
kubectl get deployment
```

Look at the **Ready** column:
- :white_check_mark: How many POD's should the deployment have?
- :white_check_mark: How many are ready ?

Go to your landing zone URL, eg: https://sokube-k8s-training.hidora.com/tatooine/.
  - :white_check_mark: Look at the footer section. What has changed in the **hostname** ?

#### Upgrades

Development is going full speed and our team has come up with a much awaited feature: *completion for tasks*. They've just released version 2.0. We'll use our deployment to perform an upgrade to this version.

- :white_check_mark: Modify the previous deployment declaration and update the image to **sokubedocker/simple-todo:2.0** (**solution** [here](./solutions/simple-todo-pod-deployment-newfeature.yaml))

