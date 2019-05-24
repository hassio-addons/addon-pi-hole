ARG BUILD_FROM=hassioaddons/base:3.1.1
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV PATH="${PATH}:/opt/pihole" \
    CORE_TAG="v4.3" \
    WEB_TAG="v4.3" \
    FTL_TAG="v4.3"

# We need to copy in the patches need during build
COPY rootfs/patches /patches

# Setup base
# hadolint ignore=DL3003
RUN \
    apk add --no-cache --virtual .build-dependencies \
        gcc=8.3.0-r0 \
        make=4.2.1-r2 \
        musl-dev=1.1.20-r4 \
        libexecinfo-dev=1.1-r0 \
        linux-headers=4.18.13-r1 \
        nettle-dev=3.4.1-r0 \
        build-base=0.5-r1 \
    \
    && apk add --no-cache \
        bash=4.4.19-r1 \
        bc=1.07.1-r0 \
        bind-tools=9.12.4_p1-r1 \
        coreutils=8.30-r0 \
        git=2.20.1-r0 \
        grep=3.1-r2 \
        libcap=2.26-r0 \
        libxml2=2.9.9-r1 \
        logrotate=3.15.0-r0 \
        ncurses=6.1_p20190105-r0 \
        nginx=1.14.2-r1 \
        openssl=1.1.1b-r1 \
        perl=5.26.3-r0 \
        php7-fileinfo=7.2.18-r0 \
        php7-fpm=7.2.18-r0 \
        php7-json=7.2.18-r0 \
        php7-opcache=7.2.18-r00 \
        php7-openssl=7.2.18-r0 \
        php7-phar=7.2.18-r0 \
        php7-session=7.2.18-r0 \
        php7-sockets=7.2.18-r0\
        php7-sqlite3=7.2.18-r0 \
        php7-zip=7.2.18-r0 \
        procps=3.3.15-r0 \
        psmisc=23.2-r1 \
        sed=4.5-r0 \
        sudo=1.8.25_p1-r2 \
        wget=1.20.3-r0 \
    \
    && addgroup -S pihole \
    && adduser -S -s /sbin/nologin pihole pihole \
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
    && patch -p1 < /patches/FTL/fix-poll-h-include-warning-on-musl.patch \
    && patch -p1 < /patches/FTL/no-backtrace-on-musl.patch \
    && make \
    && mv /root/FTL/pihole-FTL /usr/bin \
    && cd - \
    \
    && install -o pihole -Dm755 -d "/opt/pihole" \
    && install -o pihole -Dm755 -t "/opt/pihole" /etc/.pihole/gravity.sh \
    && install -o pihole -Dm755 -t "/opt/pihole" /etc/.pihole/advanced/Scripts/*.sh \
    && install -o pihole -Dm755 -t "/opt/pihole" /etc/.pihole/advanced/Scripts/COL_TABLE \
    \
    && cd /etc/.pihole/ \
    && patch -p1 < /patches/pihole/fix-killall-brain-damage.patch \
    && install -o pihole -Dm755 -t "/usr/local/bin" /etc/.pihole/pihole \
    \
    && rm -f -r /root/FTL \
    && apk del --purge .build-dependencies

# Copy root filesystem
COPY rootfs /

# Build arguments
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
