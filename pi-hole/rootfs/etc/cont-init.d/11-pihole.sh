#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: Pi-hole
# Persists the Pi-hole configuration and configures it
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

readonly SETUP_VARS='/data/pihole/setupVars.conf'
declare interface
declare ip
declare ip_gua
declare ip_ula
declare ips
declare result

if ! hass.file_exists "${SETUP_VARS}"; then
    hass.log.debug 'Initializing Pi-hole configuration on persistent storage'
    mkdir -p /data/pihole
    cp /etc/pihole/* /data/pihole
fi

hass.log.debug 'Symlinking configuration'
rm -fr /etc/pihole
ln -s /data/pihole /etc/pihole

hass.log.debug 'Setting Pi-hole interface'
if hass.config.has_value 'interface'; then
    hass.log.debug 'Using interface set in configuration'
    interface=$(hass.config.get 'interface')
else
    hass.log.debug 'Detecting interface to use with Pi-hole'
    interface=$(awk '{for (i=1; i<=NF; i++) if ($i~/dev/) print $(i+1)}' <<< "$(ip route get 8.8.8.8)")
fi
hass.log.debug "Setting interface to: ${interface}"
sed -i "s/PIHOLE_INTERFACE.*/PIHOLE_INTERFACE=${interface}/" "${SETUP_VARS}"

hass.log.debug 'Setting Pi-hole IPv4 address'
if hass.config.has_value 'ipv4_address'; then
    hass.log.debug 'Using IPv4 address from configuration'
    ip=$(hass.config.get 'ipv4_address')
else
    hass.log.debug 'Detecting IPv4 address to use with Pi-hole'
    ip=$(ip -o -f inet addr show "${interface}" |  awk '{print $4}' | awk 'END {print}')
fi
hass.log.debug "Setting IPv4 address to: ${ip}"
sed -i "s#IPV4_ADDRESS.*#IPV4_ADDRESS=${ip}#" "${SETUP_VARS}"

# See https://github.com/pi-hole/pi-hole/issues/1473#issuecomment-301745953
testIPv6() {
    local ips=${1}
    local first
    local value1
    local value2

    first="$(cut -f1 -d":" <<< "${ips}")"
    value1=$(((0x$first)/256))
    value2=$(((0x$first)%256))
    if (((value1&254)==252)); then 
        echo "ULA"; 
    elif (((value1&112)==32)); then
        echo "GUA"
    elif (((value1==254) && ((value2&192)==128))); then
        echo "Link-local";
    fi
    true
}

if hass.config.true 'ipv6'; then
    hass.log.debug 'Setting Pi-hole IPv6 address'
    if hass.config.has_value 'ipv6_address'; then
        hass.log.debug 'Using IPv6 address from configuration'
        ip=$(hass.config.get 'ipv6_address')
    else
        hass.log.debug 'Detecting IPv6 address to use with Pi-hole'
        ips=($(ip -6 addr show "${interface}" | grep 'scope global' | awk '{print $2}' || true))

        if [[ ! -z "${ips:-}" ]]; then
            # Determine type of found IPv6 addresses
            for i in "${ips[@]}"; do
                result=$(testIPv6 "$i")
                [[ "${result}" == "ULA" ]] && ip_ula="${i%/*}"
                [[ "${result}" == "GUA" ]] && ip_gua="${i%/*}"
            done
        fi

        # Prefer ULA over GUA or don't use any if none found
        if [[ ! -z "${ip_ula:-}" ]]; then
            hass.log.debug 'Found IPv6 ULA address'
            ip="${ip_ula}"
        elif [[ ! -z "${ip_gua:-}" ]]; then
            hass.log.debug 'Found IPv6 GUA address'
            ip="${ip_gua}"
        else
            hass.log.debug 'Found neither IPv6 ULA nor GUA address, IPv6 will be disabled'
            ip=""
        fi
    fi
    hass.log.debug "Setting IPv6 address to: ${ip}"
    sed -i "s#IPV6_ADDRESS.*#IPV6_ADDRESS=${ip}#" "${SETUP_VARS}"
else
    hass.log.debug 'Disabling IPv6'
    sed -i "s/IPV6_ADDRESS.*/IPV6_ADDRESS=/" "${SETUP_VARS}"
fi

if hass.config.has_value 'virtual_host'; then
    hass.log.debug 'Storing virtual host for Pi-hole'
    hass.config.get 'virtual_host' | tr -d '[:space:]' > /var/run/s6/container_environment/VIRTUAL_HOST
fi
