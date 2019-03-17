#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Pi-hole
# Writes the hostname of the Hass.io host computer into a file
# ==============================================================================
if bashio::supervisor.ping; then
    bashio::host.hostname > /data/hostname
fi

# Add pi.hole to hosts
echo "127.0.0.1 pi.hole" >> /etc/hosts
