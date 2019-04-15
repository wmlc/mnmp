#!/bin/bash

# echo "alias mnmp='/Users/leon/leon/bash/mnmp.sh'" >> ~/.bash_profile
# mnmp start | stop | restart

MYSQL="/usr/local/bin/mysql.server"
NGINX="/usr/local/bin/nginx"
PHPFPM="/usr/local/Cellar/php@7.2/7.2.17/sbin/php-fpm" # sys default: "/usr/sbin/php-fpm"
# PIDPATH="/usr/local/var/run"
param=$1
type=$2

status()
{
    npids=`ps aux | grep -i nginx | grep -v grep | awk '{print $2}'`
    if [ ! -n "$npids" ]; then
        echo "nginx not running"

    else
        echo "nginx is running"
    fi

    npids=`ps aux | grep -i mysql | grep -v grep | awk '{print $2}'`
    if [ ! -n "$npids" ]; then
        echo "mysql not running"

    else
        echo "mysql is running"
    fi

    npids=`ps aux | grep -i php-fpm | grep -v grep | awk '{print $2}'`
    if [ ! -n "$npids" ]; then
         echo "php-fpm not running"
    else
        echo "php-fpm is running"

    fi
}

start()
{
    npids=`ps aux | grep -i nginx | grep -v grep | awk '{print $2}'`
    if [ ! -n "$npids" ]; then
        tmp='/usr/local/var/run/nginx/fastcgi_temp'
        [ -d "$tmp" ] && sudo chmod -R 755 $tmp
        echo "starting php-fpm ..." && sudo $PHPFPM -D
        # unable to bind listening socket for address '127.0.0.1:xx': Address already in use # killall -c php-fpm

        echo "starting nginx ..." && sudo $NGINX # sudo for bind to 0.0.0.0:80
        $MYSQL start
    else
        echo "already running"
    fi
}
 
stop()
{
    # npids=`ps aux | grep -i nginx | grep -v grep | awk '{print $2}'`
    # if [ ! -n "$npids" ]; then
    #     echo "already stopped";exit;
    # fi

    echo "stopping mnmp ..."
    # $PHPFPM stop
    sudo killall -c php-fpm
    # sudo $NGINX -s stop
    sudo killall -c nginx
    # $MYSQL stop
    killall -c mysqld
}
# config()
    # nginx -V # /usr/local/etc/nginx/nginx.conf
    # mysql –verbose –help | grep -A 1 'Default options' # /usr/local/opt/mysql/my.cnf
    # /usr/local/opt/php56/sbin/php-fpm -i | grep 'Loaded Configuration File'
    # /usr/local/etc/php/5.6/php.ini, /usr/local/etc/php/5.6/php-fpm.conf, /tmp/php-fpm.log
case $param in
    'status')
        status;;
    'start')
        start;;
    'stop') 
        stop;;
    'restart')
        stop
        start;;
    *)
    echo "Usage: ./mnmp.sh status | start | stop | restart";;
esac
