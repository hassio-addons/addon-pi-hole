#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: Pi-hole
# Sets the configured password for the Pi-hole admin interface
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

if ! hass.config.has_value 'password'; then
    hass.log.warning 'No password set! This is not recommended!'
fi
pihole -a -p "$(hass.config.get 'password')"
