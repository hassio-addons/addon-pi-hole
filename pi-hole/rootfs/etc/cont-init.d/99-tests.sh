#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: Pi-hole
# Some final checks before stuff is actually started
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

hass.log.debug 'Testing if all configurations valid'
pihole-FTL dnsmasq-test -7 /etc/dnsmasq.d
php-fpm7 -t
nginx -t
