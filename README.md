# Kubernetes Training

> **Description:** ...

### Available Courses :

 - [01 - Core concepts (Example)](https://github.com/sokube/kubernetes-training/tree/master/courses/01-core-concepts)

### Including a new course : 


    ## courses/Dockerfile
    
    COPY example/example.html /reveal.js
    
    RUN sed -i gulpfile.js -e "s/index\.html/example\/**/"

