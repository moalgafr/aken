FROM alpine:3.19

RUN	apk --update add --no-cache nginx openssl

RUN mkdir -p /etc/nginx /run/nginx /usr/share/nginx/html /etc/nginx/certs

# COPY ./tools/* /etc/nginx/ssl/.
WORKDIR /var/www/html/

EXPOSE 443

COPY ./conf/wp.conf /etc/nginx/nginx.conf

RUN chown -R nginx:nginx /usr/share/nginx/html /var/www/html/ && \
  chown -R nginx:nginx /etc/nginx/certs/

CMD ["nginx", "-g", "daemon off;", "-c", "/etc/nginx/nginx.conf"]