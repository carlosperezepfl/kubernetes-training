# LAB-K8S-06: NetworkPolicies

**Description**: In this lab, we will be discussing some fairly advanced notions that are NetworkPolicies. These objects make it possible to control who can talk to whom. 

(pod-1/service-1 <---> pod2/service-2)

**Duration**: ±20m

## Goals
At the end of this lab, the objective is to understand that Kubernetes has by default a non-restrictive policy, one of the expressions that often comes up: "anyone can talk to anyone" and that to restrict this policy, nothing better than the NetworksPolicies that we will discuss in this lab.

## Prerequisites
 - [LAB-K8S-01 - Basic Setup](../LAB-K8S-01/README.MD)
 - [LAB-K8S-03 - PODs](../LAB-K8S-03/README.MD)
 - [LAB-K8S-04 - Services](../LAB-K8S-04/README.MD)
 - [LAB-K8S-05 - Deployments](../LAB-K8S-05/README.MD)
 - 
 -
 
---
## NetworkPolicies 
Let's take a quick look at what a NetworkPolicies object looks like :

``` shell
    $ cat networkPolicies-example.yml
```
Logically, certain notions should speak to you, as you can see, there are labels... Let's take a closer look at this and take the opportunity to quickly browse through the official documentation : 

- Read | [Concepts - NetworkPolicies](https://kubernetes.io/docs/concepts/services-networking/network-policies/#networkpolicy-resource)

As you can see, there are several keys :

- Selectors : Enforcement of rules
 - podSelector : Selecting a group of pods (If MatchLabels = Labels in pod) 
 - namespaceSelector : Selecting a namespace (If MatchLabels = Labels in namespace)
 - ipBlock : 
- PolicyTypes: 
 - Ingress : Outgoing traffic rule
 - Egress : Incoming traffic rule
- ingress (from) & egress (to) : "Whitelist"

> WARN : In the case of a podSelector: {}, all pods in the current namespace are selected, this empty parameter works the same way on ingress: {} or egress:{}.
