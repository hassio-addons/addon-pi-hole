#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: Pi-hole
# Configures NGINX for use with Pi-hole
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

declare http_port
declare https_port
declare certfile
declare keyfile

http_port=$(hass.config.get 'http_port')
https_port=$(hass.config.get 'https_port')

if hass.config.true 'ssl'; then
    rm /etc/nginx/nginx.conf
    mv /etc/nginx/nginx-ssl.conf /etc/nginx/nginx.conf

    certfile=$(hass.config.get 'certfile')
    keyfile=$(hass.config.get 'keyfile')

    sed -i "s/%%certfile%%/${certfile}/g" /etc/nginx/nginx.conf
    sed -i "s/%%keyfile%%/${keyfile}/g" /etc/nginx/nginx.conf
    sed -i "s/%%https_port%%/${https_port}/g" /etc/nginx/nginx.conf
fi

sed -i "s/%%http_port%%/${http_port}/g" /etc/nginx/nginx.conf

if ! hass.config.true 'ipv6'; then 
    sed -i '/listen \[::\].*/ d' /etc/nginx/nginx.conf
fi
