FROM alpine:3.19

RUN apk update && apk upgrade && apk add --no-cache \
    curl \
    php \
    php-fpm \
    php-mysqli \
    php-json \
    php-curl \
    php-phar \
    php-dom \
    php-exif \
    php-fileinfo \
    php-mbstring \
    php-openssl \
    php-xml \
    php-zip \
    unzip && \
    sed -i "s|listen = 127.0.0.1:9000|listen = 9000|g" /etc/php82/php-fpm.d/www.conf && \
    sed -i "s|;listen.owner = nobody|listen.owner = nobody|g" /etc/php82/php-fpm.d/www.conf && \
    sed -i "s|;listen.group = nobody|listen.group = nobody|g" /etc/php82/php-fpm.d/www.conf

RUN mkdir -p /var/www/html/wordpress
WORKDIR /var/www/html/wordpress

# downloading wp-cli executable
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/bin/wp

# RUN wget https://wordpress.org/latest.zip && \
#     unzip latest.zip && \
#     cp -rf wordpress/* . && \
#     rm -rf wordpress latest.zip

COPY tools/wp-script.sh ./wp-script.sh
RUN chmod +x ./wp-script.sh
# RUN chmod -R 777 wp-content

# RUN /wp-script.sh
CMD ["sh", "wp-script.sh"]
# CMD ["/usr/sbin/php-fpm82", "-F"]
