#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Pi-hole
# Persists the Pi-hole configuration and configures it
# ==============================================================================
readonly SETUP_VARS='/data/pihole/setupVars.conf'
declare interface
declare ip
declare ip_gua
declare ip_ula
declare ips
declare result

if ! bashio::fs.file_exists "${SETUP_VARS}"; then
    bashio::log.debug 'Initializing Pi-hole configuration on persistent storage'
    mkdir -p /data/pihole
    cp /etc/pihole/* /data/pihole
fi

# Copy "possible" missing files, due to upgrades
if ! bashio::fs.file_exists '/data/pihole/localbranches'; then
    cp /etc/pihole/localbranches /data/pihole
fi

if ! bashio::fs.file_exists '/data/pihole/GitHubVersions'; then
    cp /etc/pihole/GitHubVersions /data/pihole
fi

bashio::log.debug 'Symlinking configuration'
rm -fr /etc/pihole
ln -s /data/pihole /etc/pihole
chmod 777 /data/pihole

bashio::log.debug 'Setting Pi-hole interface'
if bashio::config.has_value 'interface'; then
    bashio::log.debug 'Using interface set in configuration'
    interface=$(bashio::config 'interface')
else
    bashio::log.debug 'Detecting interface to use with Pi-hole'
    interface=$(awk '{for (i=1; i<=NF; i++) if ($i~/dev/) print $(i+1)}' <<< "$(ip route get 8.8.8.8)")
fi
bashio::log.debug "Setting interface to: ${interface}"
sed -i "s/PIHOLE_INTERFACE.*/PIHOLE_INTERFACE=${interface}/" "${SETUP_VARS}"

bashio::log.debug 'Setting Pi-hole IPv4 address'
if bashio::config.has_value 'ipv4_address'; then
    bashio::log.debug 'Using IPv4 address from configuration'
    ip=$(bashio::config 'ipv4_address')
else
    bashio::log.debug 'Detecting IPv4 address to use with Pi-hole'
    ip=$(ip -o -f inet addr show "${interface}" |  awk '{print $4}' | awk 'END {print}')
fi
bashio::log.debug "Setting IPv4 address to: ${ip}"
sed -i "s#IPV4_ADDRESS.*#IPV4_ADDRESS=${ip}#" "${SETUP_VARS}"

# See https://github.com/pi-hole/pi-hole/issues/1473#issuecomment-301745953
testIPv6() {
    local ips=${1}
    local first
    local value1
    local value2

    # first will contain fda2 (ULA)
    first="$(cut -f1 -d":" <<< "${ips}")"

    # value1 will contain 253 which is the decimal value corresponding to 0xfd
    value1=$(((0x$first)/256))

    # Will contain 162 which is the decimal value corresponding to 0xa2
    value2=$(((0x$first)%256))

    # The ULA test is testing for fc00::/7 according to RFC 4193
    if (((value1&254)==252)); then
        echo "ULA";
    fi

    # The GUA test is testing for 2000::/3 according to RFC 4291
    if (((value1&112)==32)); then
        echo "GUA"
    fi

    # The LL test is testing for fe80::/10 according to RFC 4193
    if (((value1==254) && ((value2&192)==128))); then
        echo "Link-local";
    fi

    true
}

if bashio::config.true 'ipv6'; then
    bashio::log.debug 'Setting Pi-hole IPv6 address'
    if bashio::config.has_value 'ipv6_address'; then
        bashio::log.debug 'Using IPv6 address from configuration'
        ip=$(bashio::config 'ipv6_address')
    else
        bashio::log.debug 'Detecting IPv6 address to use with Pi-hole'
        mapfile -t ips < <(ip -6 addr show "${interface}" | grep 'scope global' | awk '{print $2}' || true)

        if [[ -n "${ips:-}" ]]; then
            # Determine type of found IPv6 addresses
            for i in "${ips[@]}"; do
                result=$(testIPv6 "$i")
                [[ "${result}" == "ULA" ]] && ip_ula="${i%/*}"
                [[ "${result}" == "GUA" ]] && ip_gua="${i%/*}"
            done
        fi

        # Prefer ULA over GUA or don't use any if none found
        if [[ -n "${ip_ula:-}" ]]; then
            bashio::log.debug 'Found IPv6 ULA address'
            ip="${ip_ula}"
        elif [[ -n "${ip_gua:-}" ]]; then
            bashio::log.debug 'Found IPv6 GUA address'
            ip="${ip_gua}"
        else
            bashio::log.debug 'Found neither IPv6 ULA nor GUA address, IPv6 will be disabled'
            ip=""
        fi
    fi
    bashio::log.debug "Setting IPv6 address to: ${ip}"
    sed -i "s#IPV6_ADDRESS.*#IPV6_ADDRESS=${ip}#" "${SETUP_VARS}"
else
    bashio::log.debug 'Disabling IPv6'
    sed -i "s/IPV6_ADDRESS.*/IPV6_ADDRESS=/" "${SETUP_VARS}"
fi

if bashio::config.has_value 'virtual_host'; then
    bshio::log.debug 'Storing virtual host for Pi-hole'
    bashio::config 'virtual_host' | tr -d '[:space:]' > /var/run/s6/container_environment/VIRTUAL_HOST
fi

bashio::log.debug 'Setting Pi-hole Query Logging state'
# shellcheck disable=SC1091
source /data/pihole/setupVars.conf
if [[ "${QUERY_LOGGING}" = false ]]; then
    sed -i 's/^log-queries/#log-queries/' /etc/dnsmasq.d/01-pihole.conf
fi

# Write current version information
echo -n "${CORE_TAG} ${WEB_TAG} ${FTL_TAG}" > /etc/pihole/localversions
