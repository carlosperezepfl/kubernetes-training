# Kubernetes Training

> **Description:** ...

### Available Courses :

 - [LAB-K8S-01 - Basic Setup](./LAB-K8S-01/README.MD)
 - [LAB-K8S-02 - Docker](./LAB-K8S-02/README.MD)
 - [LAB-K8S-03 - PODs](./LAB-K8S-03/README.MD)
 - [LAB-K8S-04 - Services](./LAB-K8S-04/README.MD)
 - [LAB-K8S-05 - Deployment](./LAB-K8S-05/README.MD)
 - [LAB-K8S-06 - Config Maps & Environment Variables](./LAB-K8S-06/README.MD)

### Including a new course : 


    ## courses/Dockerfile
    
    COPY example/example.html /reveal.js
    
    RUN sed -i gulpfile.js -e "s/index\.html/example\/**/"

