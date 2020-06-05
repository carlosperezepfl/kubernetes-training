

# LAB-K8S-05: Deployment

**Description**: For this lab, the participants will learn how to use Deployments inside Kubernetes, and will practise roll-outs of new versions as well as roll-backs.

**Duration**: ±30m

## Goals
At the end of this lab, each participant will be able to roll-out and roll-back a new version of an application with a Deployment object both in imperative and declarative ways.

## Prerequisites
 - [LAB-K8S-01 - Basic Setup](../LAB-K8S-01/README.MD)

----

## 

- Look at your application using your landing zone, eg: https://sokube-k8s-training.hidora.com/tatooine
- Is your application still running ?


## Using Deployments
 
- Create a deployment inside your namespace using the following specification:


``` yaml
----
apiVersion: v1
kind: Deployment
metadata:
  name: my-app-deployment
  namespace: <YOURNAMESPACE>
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
        - name: my-simple-todolist
          image: <TBD>
          ports:
          - containerPort: 8080
``` 

- Step 2:
