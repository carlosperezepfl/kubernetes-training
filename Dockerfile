FROM node:lts-buster-slim

LABEL maintainer="Fabrice Vergnenegre <fabrice.vergnenegre@sokube.ch>, Quentin HENNEAUX <quentin.henneaux@sokube.ch>" \
      build_date="02-06-2020" \
      io.k8s.description="RevealJS" \
      io.k8s.display-name="RevealJS"
	  
RUN apt-get update -y \
    && apt-get install -y \
        tini \
        wget \
        g++ \
        make \
        python \
    && apt-get clean -y 

RUN wget -qO /tmp/reveal.js.tar.gz https://github.com/hakimel/reveal.js/archive/4.0.2.tar.gz \
    && tar -xvf /tmp/reveal.js.tar.gz \
    && mkdir /opt/node_app \
    && mv reveal.js-4.0.2 /reveal.js

RUN mkdir -p /reveal.js/node_modules \
    && npm i --g gulp-cli \
    && npm i gulp -D \
    && npm i --prefix /reveal.js \
    && npm cache clean --force \
    && rm -rf /root/.node-gyp /tmp/npm* /tmp/phantomjs /var/lib/apt/lists/*

WORKDIR /reveal.js

RUN chown -R node:node /reveal.js

USER node

EXPOSE 8000

ENTRYPOINT ["tini", "--"]
CMD ["gulp", "serve"]
