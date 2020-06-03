FROM mowhank/kubernetes-training-core:1.0.0

LABEL maintainer="Fabrice Vergnenegre <fabrice.vergnenegre@sokube.ch>, Quentin HENNEAUX <quentin.henneaux@sokube.ch>" \
      build_date="02-06-2020" \
      io.k8s.description="Courses" \
      io.k8s.display-name="Courses"

COPY 01-core-concepts  /reveal.js

RUN sed -i gulpfile.js -e "s/index\.html/01-core-concepts\/**/"

CMD ["gulp", "serve"]
