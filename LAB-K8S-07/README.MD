# LAB-K8S-07: Secrets

**Description**: In this lab, participants will learn how to create and use **Secrets**.

**Duration**: ±40m

## Goals
At the end of this laboratory, each participant will be able to_
- Create a Secret object
- Use the same Secret in applications

## Prerequisites
 - [LAB-K8S-01 - Basic Setup](../LAB-K8S-01/README.MD)
 - [LAB-K8S-03 - PODs](../LAB-K8S-03/README.MD)
 - [LAB-K8S-04 - Services](../LAB-K8S-04/README.MD)
 - [LAB-K8S-05 - Deployments](../LAB-K8S-05/README.MD)
 - [LAB-K8S-06 - ConfigMaps](../LAB-K8S-06/README.MD)

---
## Secrets

Secrets allow to store and manage sensitive information on a (key/value) model. They are commonly used for passwords, OAuth token ... 
Secrets objects are very similar to ConfigMaps.

:warning: Kubernetes Secrets are **not secure** at all as they rely on base64 encoding, and should be avoided as much as possible in production environments. There are secure alternatives to native secrets, such as Hashicorp [Vault](https://www.vaultproject.io/). Such a tool setup and usage would require a dedicated lab.

I've just been informed that a droid has just delivered an encoded message. 

**Let's check it out.** 

>**WARN :** Beware however, a secret is not encrypted, but simply encoded in base64, secure safe alternatives exist and MUST be used for any production-type deployment. 

 - :white_check_mark: Read documentation on [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
 
It's time to go and see what's in this message.

Let's start by injecting it into the kube :

:fire: TODO :fire: 

### Creating a Secret :

- First, add the secret-transmission-1.yml :
``` shell
kubectl create -f secret-transmission-1.yml
```
- Once deployed, it's time to see what's inside :

- According to the reports of our "Identity" service, the encoding seems to be base64, decode it!

- We have access to the Empire's internal network to find out how to decode it :
www.google.com

> base64 decode/encode

- Congratulations, it seems we still need your services, we must convey the content of this message :

> **MENACE :** 

"Please bring the Death Star plans attached to this message to {{name your planet}}" and this ascii code (after the text) : https://github.com/sokube/kubernetes-training/blob/master/LAB-K8S-07/death-star-ascii

- Encode this message and insert it in a new secret (secret-transmission-2.yml)
  ``` shell
  kubectl create -f secret-transmission-2.yml
  ```

- Let's make sure it's been created :
  ``` shell
  kubectl get secrets
  ```  

- The message is waiting within the kube. Let's make sure it gets to the Rebel Alliance. - (**solution**  [here](https://github.com/sokube/kubernetes-training/blob/master/LAB-K8S-07/solutions/01-simple-todo-pod-deployment-secret-env.yml)) 

- Add to your deployment the volume mount your secret :  Read | [Configurations - Using Secrets as environment variables](https://kubernetes.io/docs/concepts/configuration/secret/#using-secrets-as-environment-variables)

> TIPS: Export your old deployment and simply add the new entries. | kubectl get deployment my-todo-deployment -o yaml > my-todo-deployment-with-secret-env.yml

- Let us also make sure that the secret cannot be changed, but can be read by our operators ! Read | [Configurations - Immutable](https://kubernetes.io/docs/concepts/configuration/secret/#mounted-secrets-are-updated-automatically) && [Configurations - Secret files permissions](https://kubernetes.io/docs/concepts/configuration/secret/#secret-files-permissions)

- 🔥 Send the message, now! The Empire fleet is approaching! 🔥
  ``` shell
  kubectl apply -f my-todo-deployment-with-secret-env.yml
  ```  

- We're running out of time! It's time to leave ! 

## Next lab

- [LAB-K8S-08 - Persistence](../LAB-K8S-08/README.MD)
