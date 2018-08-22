#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: Pi-hole
# Adds custom configured hosts to the DNS resolver
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

declare name
declare ip

for host in $(hass.config.get 'hosts|keys[]'); do
    name=$(hass.config.get "hosts[${host}].name")
    ip=$(hass.config.get "hosts[${host}].ip")
    hass.log.debug "Adding host: ${name} resolves to ${ip}"
    echo "${ip} ${name}" >> /etc/hosts.list
done
