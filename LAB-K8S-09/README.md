# LAB-K8S-09: NetworkPolicies

**Description**: In this lab, we will be discussing some fairly advanced notions that are NetworkPolicies. This object make it possible to control communication between pods in cluster

**Duration**: ±25m

## Goals
At the end of this lab, the objective is to understand that Kubernetes has by default a non-restrictive policy (namespace), one of the expressions that often comes up: "anyone can talk to anyone in current context" and that to restrict this policy, nothing better than the NetworksPolicies that we will discuss in this lab.

## Prerequisites
 - [LAB-K8S-01 - Basic Setup](../LAB-K8S-01/README.MD)
 - [LAB-K8S-03 - PODs](../LAB-K8S-03/README.MD)
 - [LAB-K8S-04 - Services](../LAB-K8S-04/README.MD)
 - [LAB-K8S-05 - Deployments](../LAB-K8S-05/README.MD)
 
---

![configmap-example](https://banzaicloud.com/img/blog/network-security/network-policy.png)

## NetworkPolicies 
- ✅ Let's take a quick look at what a NetworkPolicies object looks like :

``` shell
    $ cat network-policies-example-1.yml
```

Logically, certain notions should speak to you, as you can see, there are labels... Let's take a closer look at this and take the opportunity to quickly browse through the official documentation : 

- ✅ Read | [Concepts - NetworkPolicies](https://kubernetes.io/docs/concepts/services-networking/network-policies/#networkpolicy-resource)

As you can see, there are several keys :

- Selectors : Enforcement of rules
   - podSelector : Selecting a group of pods (If MatchLabels = Labels in pod) 
   - namespaceSelector : Selecting a namespace (If MatchLabels = Labels in namespace)
   - IpBlock : This selects particular IP CIDR ranges to allow as ingress sources or egress destinations.
- PolicyTypes: 
   - Ingress : Incoming traffic rule
   - Egress : Outgoing traffic rule
   - ingress (from) & egress (to) : "Whitelist"

> **WARN 1** : In the case of a podSelector: {}, all pods in the current namespace are selected, this empty parameter works the same way on ingress: {} or egress:{}.

> **WARN 2** Due to the ephemeral nature of PODs and of their IP addresses, it is preferrable to rely on podSelectors rather than ipBlocks to design network policies.

--- 

### QUIZZ :

✅ Let's look at the simple rules :

``` shell
    $ cat example-1.yml
```

``` shell
    $ cat example-2.yml
```

``` shell
    $ cat example-3.yml
```

### For every rule, tell me what it is. 
---

✅ Let's go back to the network-policies-example.yml to make it a bit more complex :

``` shell
    $ vim network-policies-example-1.yml
```

- ✅ Let's add one or more rules allowing an operator (which we will call Watto) to communicate with the pod (postgresql)

> **INFO** Please note that operators have their own namespace (chaos) (for security reasons, activity monitoring, etc.). 

- ✅ Done ? Let's see what it looks like ! 

``` shell
    $ cat network-policies-example-2.yml
```

### TIPS :

- Typically, a namespace to namespace rule pattern is used for networksPolicies. Then of course it depends on the architecture (project-based namespace, specialized namespace etc.).
- Ingress VS Egress
 
### Next lab
 - [LAB-K8S-10 - Ingress](../LAB-K8S-10/README.MD)
