#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Pi-hole
# Some final checks before stuff is actually started
# ==============================================================================
bashio::log.debug 'Testing if all configurations valid'
pihole-FTL dnsmasq-test -7 /etc/dnsmasq.d
php-fpm7 -t
nginx -t
