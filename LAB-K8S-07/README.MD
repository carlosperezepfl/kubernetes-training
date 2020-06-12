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

>:warning: Kubernetes Secrets are **not secure** at all as they rely on base64 encoding, and should be avoided as much as possible in production environments. There are secure alternatives to native Secrets, such as Hashicorp [Vault](https://www.vaultproject.io/).
>
> Such a tool setup and usage would require a dedicated lab. 

#### A New Hope

We've just been informed that a droid has just delivered under cover an encoded message in the form of a **Secret** inside your namespace. Let's check it out...

 - :white_check_mark: Read documentation on [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
 - :white_check_mark: Can you see the **Secret** object inside your namespace?
   ``` shell
   kubectl get secrets
   ```
- :white_check_mark: What does the **describe** command show ?
   ``` shell
   kubectl describe secrets secret-transmission-from-droid 
   ```
- :white_check_mark: Show the secret content using the YAML format
   ``` shell
   kubectl get secrets secret-transmission-from-droid -o yaml
   ```
- :white_check_mark: Retrieve the content of the **message** entry in the **data** section, and **decode** it

   ``` shell
   kubectl get secrets secret-transmission-from-droid -o yaml | \
    grep -oP "message: \K(.*)" | base64 --decode
   ```

We've been assigned an important mission, bring the Death Star plans to the Rebels. We've immediately tasked our application team to develop a way to access our broadcast message containing the plans.

#### Preparing the broadcast transmission

This is the message we want to store *safely* as a Secret (we've covered already the topic of how secure this is)

  > **MENACE!** 
  >"Message from {{planet}} to all Rebels: Please bring the Death Star plans attached to this message to someone named Obi-Wan-Kenobi" 
  > \+ this ascii code (after the text) : https://github.com/sokube/kubernetes-training/blob/master/LAB-K8S-07/death-star-ascii

- :white_check_mark: Encode this message (base64) and insert it in a new secret named **secret-transmission**, inside the data field **secret-transmission.txt** :
  ``` shell
  kubectl create -f secret-transmission-2.yml
  ```

- :white_check_mark: Verify it's been created:
  ``` shell
  kubectl get secrets
  ```  

Our Rebel-loving dev application team has quickly rushed a new version of our landing zone application and provided us a quick and dirty way to offer the transmission my mounting the secret **as a file inside the container filesystem** at /usr/src/app/static/transmission/. They've also provided a **new link on the main page** to facilitate the job of the Rebels.

- :white_check_mark: Deploy a new version of our application (image: **sokubedocker:simple-todo:v2.2**) and check this new "feature".
  > TIPS: If you don't have the previous deployments yaml files, Export your old deployment and simply add the new entries. | kubectl get deployment my-todo-deployment -o yaml > my-todo-deployment-with-secret-volume.yml

Frightening. Time to put the real message.

- :white_check_mark: Read the documentation on [Pods and Secrets as volumes](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#create-a-pod-that-has-access-to-the-secret-data-through-a-volume)

- :white_check_mark: Update the deployment to mount the secret's content as files under **/usr/src/app/static/transmission/** in the container. (**solution**  [here](./solutions/01-simple-todo-pod-deployment-secret-volume.yml)) 

- :white_check_mark: Check that our message can be seen correctly

:cocktail: **Congratulations, you've reached mastery in the management of Secrets** :cocktail:

## Advanced Topic: Service Accounts Secrets

- :white_check_mark: Create the debug pod that we've used in [LAB-K8S-08 - Persistence](../LAB-K8S-04/README.MD) for debugging purposes.
   ``` shell
   kubectl create -f debug-pod.yml
   ``` 

- :white_check_mark: Check its description... What is this **Secret** that we have not defined by ourselves ?
  ```
  ...
      Environment:    <none>
      Mounts:
        /var/run/secrets/kubernetes.io/serviceaccount from   default-token-gb7gb (ro)
  Conditions:
    Type              Status
    Initialized       True 
    Ready             True 
    ContainersReady   True 
    PodScheduled      True 
  Volumes:
    default-token-gb7gb:
      Type:        Secret (a volume populated by a Secret)
      SecretName:  default-token-gb7gb
      Optional:    false
  ...
  ``` 

- :white_check_mark:  Check the default **Service Account** and have a look at the secret it has defined to store a token to this service. Looks familiar ?
  ```shell
  kubectl get sa default -o yaml
  ```
  ```
  apiVersion: v1
  kind: ServiceAccount
  metadata:
    creationTimestamp: "2020-06-08T15:57:17Z"
    name: default
    namespace: tatooine
    resourceVersion: "554637"
    selfLink: /api/v1/namespaces/tatooine/serviceaccounts/default
    uid: ff5f1745-76a4-4790-9132-cbac285a1530
  secrets:
  - name: default-token-gb7gb
  ```

So by default, **Kubernetes** will mount the token information for the Service Account that is used to run the POD in the /var/run/secrets/kubernetes.io/serviceaccount path on the containers of the POD.

- :white_check_mark: Explore the contents of this secret
  ``` shell
  kubectl get secret default-token-gb7gb -o yaml
  ```
  > **From** https://medium.com/better-programming/k8s-tips-using-a-serviceaccount-801c433d0023
  >
  >There are several key/value pairs under the data key of this Secret.
  > Basically:
  >- ca.crt is the Base64 encoding of the cluster certificate.
  >- namespace is the Base64 encoding of the current namespace 
  >- token is the Base64 encoding of the JWT used to authenticate against the API server.

- :white_check_mark: Copy the content of the **token** field, and use jwt.io to parse it.
  > {
  "iss": "kubernetes/serviceaccount",
  "kubernetes.io/serviceaccount/namespace": "tatooine",
  "kubernetes.io/serviceaccount/secret.name": "default-token-gb7gb",
  "kubernetes.io/serviceaccount/service-account.name": "default",
  "kubernetes.io/serviceaccount/service-account.uid": "ff5f1745-76a4-4790-9132-cbac285a1530",
  "sub": "system:serviceaccount:tatooine:default"
  }

- :white_check_mark: Go inside the mounted secret:
  ``` shell
  cd /run/secrets/kubernetes.io/serviceaccount/
  ```

- :white_check_mark: Copy the content of the JWT token inside a variable TOKEN (for clarity)
  ``` shell
  TOKEN=$(cat token)
  ``` 

- :white_check_mark: Now we can curl the kubernetes API Service using the DNS notation we've seen in [LAB-K8S-04 - Services](../LAB-K8S-04/README.MD). Remember that we're not in the default namespace where this ClusterIP service is running, so we need to use the servicename.namespace notation.
  ```shell
  curl -H "Authorization: Bearer $TOKEN" \
  "https://kubernetes.default/api/v1/" --cacert ca.crt
  ```

With this mechanism, we could for example implement a monitoring application that performs queries against the Kubernetes Cluster. 

## Next lab

- [LAB-K8S-08 - Persistence](../LAB-K8S-08/README.MD)
