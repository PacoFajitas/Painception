FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx openssl

COPY ./conf/default /etc/nginx/sites-enabled/default

COPY ./tools/nginx_www.sh /var/www

RUN chmod +x /var/www/nginx_www.sh

EXPOSE 443

ENTRYPOINT [ "/var/www/nginx_www.sh" ]

CMD ["nginx", "-g", "daemon off;"]