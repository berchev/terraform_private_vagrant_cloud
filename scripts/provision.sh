#!/usr/bin/env bash

# Install nginx
[ -d "/var/www" ] || {
  apt update
  apt install nginx -y
}

# Create main directory structure of the webserver
[ -d "/var/www/vagrant" ] || {
  mkdir -p /var/www/vagrant/xenial64/boxes
  cp /tmp/xenial64.json /var/www/vagrant/xenial64/
}

# Setup webserver
[ -f "/etc/nginx/sites-enabled/default" ] && rm -rf /etc/nginx/sites-enabled/default

[ -f "/etc/nginx/sites-available/localhost" ] || {
  cp /tmp/nginx.conf /etc/nginx/sites-available/localhost
  ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/000-localhost
}

# Make suure nginx unit is fully operational
systemctl restart nginx.service
systemctl is-enabled --quiet nginx.service || systemctl enable nginx.service
systemctl is-active --quiet nginx.service || systemctl start nginx.service
