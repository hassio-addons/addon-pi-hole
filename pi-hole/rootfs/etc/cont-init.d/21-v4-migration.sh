#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Pi-hole
# Handles the migration of existing installation to v4
# ==============================================================================
# If no data is detected, skip this part
if ! bashio::fs.directory_exists '/data/pihole'; then
    exit 0
fi

# Copy "possible" missing files, due to upgrades
if ! bashio::fs.file_exists '/data/pihole/pihole-FTL.conf'; then
    cp /etc/pihole/pihole-FTL.conf /data/pihole/pihole-FTL.conf
fi

# Change the user/group running DNSMasq/pihole-FTL
if bashio::fs.file_exists '/data/dnsmasq.d/99-addon.conf'; then
    sed -i "s/user=.*/user=pihole/" /data/dnsmasq.d/99-addon.conf
    sed -i "s/group=.*/group=pihole/" /data/dnsmasq.d/99-addon.conf
fi
