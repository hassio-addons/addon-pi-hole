ARG BUILD_FROM=hassioaddons/base:2.0.1
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

ENV PATH="${PATH}:/opt/pihole" \
    CORE_TAG="v3.3.1" \
    WEB_TAG="v3.3" \
    FTL_TAG="v3.0"

# Setup base
# hadolint ignore=DL3003
RUN \
    apk add --no-cache --virtual .build-dependencies \
        gcc=6.4.0-r5 \
        make=4.2.1-r0 \
        musl-dev=1.1.18-r3 \
    \
    && apk add --no-cache \
        bash=4.4.19-r1 \
        bc=1.07.1-r0 \
        bind-tools=9.11.3-r0 \
        coreutils=8.28-r0 \
        dnsmasq-dnssec=2.78-r1 \
        git=2.15.2-r0 \
        grep=3.1-r0 \
        libcap=2.25-r1 \
        libxml2=2.9.7-r0 \
        logrotate=3.13.0-r0 \
        ncurses=6.0_p20171125-r0 \
        nginx=1.12.2-r3 \
        openssl=1.0.2o-r0 \
        perl=5.26.2-r1 \
        php7-fileinfo=7.1.17-r0 \
        php7-fpm=7.1.17-r0 \
        php7-json=7.1.17-r0 \
        php7-opcache=7.1.17-r0 \
        php7-openssl=7.1.17-r0 \
        php7-phar=7.1.17-r0 \
        php7-session=7.1.17-r0 \
        php7-sockets=7.1.17-r0 \
        php7-sqlite3=7.1.17-r0 \
        php7-zip=7.1.17-r0 \
        procps=3.3.12-r3 \
        psmisc=23.1-r0 \
        sed=4.4-r1 \
        sudo=1.8.21_p2-r1 \
        wget=1.19.5-r0 \
    \
    && addgroup -S pihole \
    && adduser -S -s /sbin/nologin pihole pihole \
    && addgroup -S dnsmasq \
    && adduser -S -s /sbin/nologin dnsmasq dnsmasq \
    && addgroup pihole nginx \
    \
    && git clone --branch "${CORE_TAG}" --depth=1 \
        https://github.com/pi-hole/pi-hole.git /etc/.pihole \
    && git -C /etc/.pihole checkout -b master \
    \
    && git clone --branch "${WEB_TAG}" --depth=1 \
        https://github.com/pi-hole/AdminLTE.git /var/www/html/admin \
    && git -C /var/www/html/admin checkout -b master \
    \
    && git clone --branch "${FTL_TAG}" --depth=1 \
        https://github.com/pi-hole/FTL.git /root/FTL \
    && git -C /root/FTL checkout -b master \
    \
    && cd /root/FTL \
    && make \
    && mv /root/FTL/pihole-FTL /usr/bin \
    && cd - \
    \
    && install -o pihole -Dm755 -d "/opt/pihole" \
    && install -o pihole -Dm755 -t "/opt/pihole" /etc/.pihole/gravity.sh \
    && install -o pihole -Dm755 -t "/opt/pihole" /etc/.pihole/advanced/Scripts/*.sh \
    && install -o pihole -Dm755 -t "/opt/pihole" /etc/.pihole/advanced/Scripts/COL_TABLE \
    && install -o pihole -Dm755 -t "/usr/local/bin" /etc/.pihole/pihole \
    \
    && rm -f -r /root/FTL \
    && apk del --purge .build-dependencies

# Copy root filesystem
COPY rootfs /

# Build arugments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Pi-hole" \
    io.hass.description="Network-wide ad blocking using your Hass.io instance" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.label-schema.description="Network-wide ad blocking using your Hass.io instance" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Pi-hole" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://community.home-assistant.io/t/community-hass-io-add-on-pi-hole/33817?u=frenck" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-pi-hole/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-pi-hole" \
    org.label-schema.vendor="Community Hass.io Addons"
