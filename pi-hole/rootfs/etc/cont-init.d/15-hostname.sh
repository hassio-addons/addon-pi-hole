#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: Pi-hole
# Writes the hostname of the Hass.io host computer into a file
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

if hass.api.supervisor.ping; then
    hass.api.host.info.hostname > /data/hostname
fi
