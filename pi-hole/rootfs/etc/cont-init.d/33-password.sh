#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Pi-hole
# Sets the configured password for the Pi-hole admin interface
# ==============================================================================
if ! bashio::config.has_value 'password'; then
    bashio::log.warning 'No password set! This is not recommended!'
fi
pihole -a -p "$(bashio::config 'password')"
