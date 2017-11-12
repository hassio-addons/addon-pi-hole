#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: Pi-hole
# Runs Gravity on startup
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

if hass.config.true 'update_lists_on_start' \
    || ! hass.file_exists "/data/pihole/gravity.list"; 
then
    hass.log.debug 'Generating block lists'
    dnsmasq -7 /etc/dnsmasq.d
    gravity.sh
    kill "$(pgrep dnsmasq)"
fi
