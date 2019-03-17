#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Pi-hole
# This files check if all user configuration requirements are met
# ==============================================================================
# Enforce authentication
if ! bashio::config.true 'leave_front_door_open'; then
    if bashio::config.true 'i_like_to_be_pwned'; then
        bashio::config.require.password
    else
        bashio::config.require.safe_password
    fi
fi

bashio::config.require.ssl
