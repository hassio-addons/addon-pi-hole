#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Pi-hole
# Adds custom configured hosts to the DNS resolver
# ==============================================================================
declare name
declare ip

for host in $(bashio::config 'hosts|keys'); do
    name=$(bashio::config "hosts[${host}].name")
    ip=$(bashio::config "hosts[${host}].ip")
    bashio::log.debug "Adding host: ${name} resolves to ${ip}"
    echo "${ip} ${name}" >> /etc/hosts.list
done
