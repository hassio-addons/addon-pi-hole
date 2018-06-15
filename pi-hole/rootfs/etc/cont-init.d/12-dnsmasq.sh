#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: Pi-hole
# Links files to more permanent storage locations and configures dnsmasq
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

declare interface
declare port

# Allow dnsmasq to bind on ports < 1024
setcap CAP_NET_ADMIN,CAP_NET_BIND_SERVICE,CAP_NET_RAW=+eip "$(command -v dnsmasq)"

if ! hass.directory_exists '/data/dnsmasq.d'; then
    hass.log.debug 'Initializing dnsmasq configuration on persistent storage'
    mkdir -p /data/dnsmasq.d
    cp -R /etc/dnsmasq.d/* /data/dnsmasq.d
fi

hass.log.debug 'Symlinking configuration'
rm -fr /etc/dnsmasq.d
ln -s /data/dnsmasq.d /etc/dnsmasq.d

hass.log.debug 'Setting dnsmasq interface'
if hass.config.has_value 'interface'; then
    hass.log.debug 'Using interface set in configuration'
    interface=$(hass.config.get 'interface')
else
    hass.log.debug 'Detecting interface'
    interface=$(awk '{for (i=1; i<=NF; i++) if ($i~/dev/) print $(i+1)}' <<< "$(ip route get 8.8.8.8)")
fi
hass.log.debug "Setting interface to: ${interface}"
sed -i "s/interface=.*/interface=${interface}/" /etc/dnsmasq.d/01-pihole.conf
sed -i "/except-interface/d" /etc/dnsmasq.d/01-pihole.conf

hass.log.debug "Ensure extra information for query log is enabled"
sed -i "s/log-queri.*/log-queries=extra/" /etc/dnsmasq.d/01-pihole.conf

hass.log.debug 'Setting dnsmasq port'
port=$(hass.config.get 'dns_port')

hass.log.debug "Setting dnsmasq port to: ${port}"
sed -i "s/port=.*/port=${port}/" /etc/dnsmasq.d/99-addon.conf
