#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Pi-hole
# Links files to more permanent storage locations and configures dnsmasq
# ==============================================================================
declare interface
declare port

# Allow dnsmasq to bind on ports < 1024
setcap CAP_NET_ADMIN,CAP_NET_BIND_SERVICE,CAP_NET_RAW=+eip "$(command -v pihole-FTL)"

if ! bashio::fs.directory_exists '/data/dnsmasq.d'; then
    bashio::log.debug 'Initializing dnsmasq configuration on persistent storage'
    mkdir -p /data/dnsmasq.d
    cp -R /etc/dnsmasq.d/* /data/dnsmasq.d
fi

bashio::log.debug 'Symlinking configuration'
rm -fr /etc/dnsmasq.d
ln -s /data/dnsmasq.d /etc/dnsmasq.d

bashio::log.debug 'Setting dnsmasq interface'
if bashio::config.has_value 'interface'; then
    bashio::log.debug 'Using interface set in configuration'
    interface=$(bashio::config 'interface')
else
    bashio::log.debug 'Detecting interface'
    interface=$(awk '{for (i=1; i<=NF; i++) if ($i~/dev/) print $(i+1)}' <<< "$(ip route get 8.8.8.8)")
fi
bashio::log.debug "Setting interface to: ${interface}"
sed -i "s/interface=.*/interface=${interface}/" /etc/dnsmasq.d/01-pihole.conf
sed -i "/except-interface/d" /etc/dnsmasq.d/01-pihole.conf

bashio::log.debug "Ensure extra information for query log is enabled"
sed -i "s/log-queri.*/log-queries=extra/" /etc/dnsmasq.d/01-pihole.conf

bashio::log.debug 'Setting dnsmasq port'
port=$(bashio::config 'dns_port')

bashio::log.debug "Setting dnsmasq port to: ${port}"
sed -i "s/port=.*/port=${port}/" /etc/dnsmasq.d/99-addon.conf

if ! bashio::fs.directory_exists '/var/run/pihole'; then
    mkdir -p /var/run/pihole
    chmod 775 /var/run/pihole
    chown pihole /var/run/pihole
fi

if ! bashio::fs.file_exists '/var/run/pihole-FTL.port'; then
    touch /var/run/pihole-FTL.port
    chmod 644 /var/run/pihole-FTL.port
    chown pihole:root /var/run/pihole-FTL.port
fi
