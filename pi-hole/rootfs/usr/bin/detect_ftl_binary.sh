#!/bin/bash
# ==============================================================================
# Community Hass.io Add-ons: Pi-hole
# Detects the correct FTL binary to use for this system
# ==============================================================================
# Note: This file is currently not used, but is here for future use.
# Pi-hole FTL is currently not available for all Hass.io archictures.
# ==============================================================================

declare machine
declare binary
declare rev
declare lib

machine=$(uname -m)
binary="pihole-FTL-linux-x86_32"

if [[ $machine == arm* || $machine == *aarch* ]]; then
    rev=$(uname -m | sed "s/[^0-9]//g;")
    lib=$(ldd /bin/ls | grep -E '^\s*/lib' | awk '{ print $1 }')

    if [[ "$lib" == "/lib/ld-linux-aarch64.so.1" ]]; then
        binary="pihole-FTL-aarch64-linux-gnu"
    elif [[ "$lib" == "/lib/ld-linux-armhf.so.3" ]]; then
        if [ "$rev" -gt "6" ]; then
            binary="pihole-FTL-arm-linux-gnueabihf"
        else
            binary="pihole-FTL-arm-linux-gnueabi"
        fi
    else
        binary="pihole-FTL-arm-linux-gnueabi"
    fi
elif [[ $machine == x86_64 ]]; then
    binary="pihole-FTL-musl-linux-x86_64"
fi

echo "${binary}"
