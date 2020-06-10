FROM nginx:1.19.0-alpine

LABEL maintainer="Fabrice Vergnenegre <fabrice.vergnenegre@sokube.ch>" \
      io.k8s.description="Vitrine Sokube" \
      io.k8s.display-name="sokube-3d"

COPY static /usr/share/nginx/html

RUN chown -R nginx /usr/share/nginx/html/*

CMD ["nginx", "-g", "daemon off;"]