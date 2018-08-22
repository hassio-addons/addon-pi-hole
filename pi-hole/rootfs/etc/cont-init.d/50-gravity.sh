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
    pihole-FTL &
    sleep 2
    gravity.sh
    kill -9 "$(pgrep pihole-FTL)" || true
fi
