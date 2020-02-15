#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Pi-hole
# This file sets up and configures DNS
# ==============================================================================
declare api_port
declare admin_port
declare certfile
declare dns_host
declare ingress_interface
declare ingress_port
declare ingress_url
declare keyfile

admin_port=$(bashio::addon.port 80)
if bashio::var.has_value "${admin_port}"; then
    bashio::config.require.ssl

    if bashio::config.true 'ssl'; then
        certfile=$(bashio::config 'certfile')
        keyfile=$(bashio::config 'keyfile')

        mv /etc/nginx/servers/direct-ssl.disabled /etc/nginx/servers/direct.conf
        sed -i "s#%%certfile%%#${certfile}#g" /etc/nginx/servers/direct.conf
        sed -i "s#%%keyfile%%#${keyfile}#g" /etc/nginx/servers/direct.conf

    else
        mv /etc/nginx/servers/direct.disabled /etc/nginx/servers/direct.conf
    fi

    sed -i "s/%%port%%/${admin_port}/g" /etc/nginx/servers/direct.conf
fi

ingress_port=$(bashio::addon.ingress_port)
ingress_interface=$(bashio::addon.ip_address)
ingress_url=$(bashio::addon.ingress_url)
sed -i "s/%%port%%/${ingress_port}/g" /etc/nginx/servers/ingress.conf
sed -i "s/%%interface%%/${ingress_interface}/g" /etc/nginx/servers/ingress.conf
sed -i "s#%%url%%#${ingress_url}#g" /etc/nginx/servers/ingress.conf

api_port=$(bashio::addon.port 4865)
if bashio::var.has_value "${api_port}"; then
    mv /etc/nginx/servers/api.disabled /etc/nginx/servers/api.conf
    sed -i "s/%%api_port%%/${api_port}/g" /etc/nginx/servers/api.conf
fi

dns_host=$(bashio::dns.host)
sed -i "s/%%dns_host%%/${dns_host}/g" /etc/nginx/includes/resolver.conf

