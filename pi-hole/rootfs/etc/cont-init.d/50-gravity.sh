#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Pi-hole
# Runs Gravity on startup
# ==============================================================================
if bashio::config.true 'update_lists_on_start' \
    || ! bashio::fs.file_exists "/data/pihole/gravity.list";
then
    bashio::log.debug 'Generating block lists'
    s6-setuidgid pihole pihole-FTL &
    sleep 2
    gravity.sh
    kill -9 "$(pgrep pihole-FTL)" || true
fi
