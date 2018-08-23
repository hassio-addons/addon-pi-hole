#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: Pi-hole
# Handles the migration of existing installation to v4
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

# If no data is detected, skip this part
if ! hass.directory_exists '/data/pihole'; then
    exit "${EX_OK}"
fi

# Copy "possible" missing files, due to upgrades
if ! hass.file_exists '/data/pihole/pihole-FTL.conf'; then
    cp /etc/pihole/pihole-FTL.conf /data/pihole/pihole-FTL.conf
fi

# Update custom DNS masq setup
if hass.directory_exists '/data/dnsmasq.d'; then
    cp /etc/dnsmasq.d/99-addon.conf /data/dnsmasq.d/99-addon.conf
fi
