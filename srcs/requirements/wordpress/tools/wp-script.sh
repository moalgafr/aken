#!/bin/bash

WP_CONFIG_FILE=wp-config.php

if [ ! -f $WP_CONFIG_FILE ]; then
    # https://make.wordpress.org/cli/handbook/how-to/how-to-install/
    # downloading wp core files
    wp core download --allow-root
    
    #wp config create --dbname=<dbname> --dbuser=<dbuser> [--dbpass=<dbpass>]
    # creating wp-config.php ..... 
    wp config create --allow-root \
        --dbname=$WP_DATABASE_NAME \
        --dbuser=$WP_DATABASE_USR \
        --dbpass=$WP_DATABASE_PWD \
        --dbhost=$MARIADB_HOST \
        --dbcharset="utf8"
    
    if [ $? -ne 0 ]; then
        echo "Failure to create wp-conf file!!!!!!!!!!!!"
        return 1
    fi
    echo "wp-conf file!!!!!!!"

    wp core install --allow-root --url=$DOMAIN_NAME \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USR \
        --admin_password=$WP_ADMIN_PWD \
        --admin_email=$WP_ADMIN_EMAIL
    if [ $? -ne 0 ]; then
        echo "Failure to create ADMIN user ......"
        return 1
    fi
    echo "created ADMIN user ......"
    
    wp user create --allow-root $WP_USR $WP_EMAIL --role=author --user_pass=$WP_PWD
    # wp user create --allow-root "student" "student@42.fr" --role=author --user_pass="s123"
    if [ $? -ne 0 ]; then
        echo "Failure to create NORMAL user ......"
        return 1
    fi
    echo "created NORMAL user ......"
fi

chown -R nginx:nginx /var/www/html/wordpress
chmod -R 755 /var/www/html/wordpress

echo "haben we here"

/usr/sbin/php-fpm82 -F
