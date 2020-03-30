ARG BUILD_FROM=hassioaddons/base:7.0.5
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV PATH="${PATH}:/opt/pihole" \
    CORE_TAG="v4.4" \
    WEB_TAG="v4.3.3" \
    FTL_TAG="v4.3.1"

# We need to copy in the patches need during build
COPY rootfs/patches /patches

# Setup base
# hadolint ignore=DL3003
RUN \
    apk add --no-cache --virtual .build-dependencies \
        gcc=9.2.0-r4 \
        make=4.2.1-r2 \
        musl-dev=1.1.24-r2 \
        libexecinfo-dev=1.1-r1 \
        linux-headers=4.19.36-r0 \
        nettle-dev=3.5.1-r0 \
        build-base=0.5-r1 \
    \
    && apk add --no-cache \
        bc=1.07.1-r1 \
        bind-tools=9.14.8-r5 \
        coreutils=8.31-r0 \
        git=2.24.1-r0 \
        grep=3.3-r0 \
        libcap=2.27-r0 \
        libxml2=2.9.10-r2 \
        logrotate=3.15.1-r0 \
        lua-resty-http=0.15-r0 \
        ncurses=6.1_p20200118-r2 \
        nettle=3.5.1-r0 \
        nginx-mod-http-lua=1.16.1-r6 \
        nginx=1.16.1-r6 \
        openssl=1.1.1d-r3 \
        perl=5.30.1-r0 \
        php7-fileinfo=7.3.16-r0 \
        php7-fpm=7.3.16-r0 \
        php7-json=7.3.16-r0 \
        php7-opcache=7.3.16-r00 \
        php7-openssl=7.3.16-r0 \
        php7-phar=7.3.16-r0 \
        php7-session=7.3.16-r0 \
        php7-sockets=7.3.16-r0\
        php7-sqlite3=7.3.16-r0 \
        php7-zip=7.3.16-r0 \
        procps=3.3.16-r0 \
        psmisc=23.3-r0 \
        sed=4.7-r0 \
        sqlite=3.30.1-r1 \
        sudo=1.8.31-r0 \
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
    && patch -p1 < /patches/FTL/fix-nettle-3.5-compat.patch \
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
    && apk del --purge .build-dependencies \
    && rm -fr \
        /etc/nginx \
        /root/FTL

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
    io.hass.description="Network-wide ad blocking" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.label-schema.description="Network-wide ad blocking" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Pi-hole" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://community.home-assistant.io/t/home-assistant-community-add-on-pi-hole/33817?u=frenck" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-pi-hole/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-pi-hole" \
    org.label-schema.vendor="Home Assistant Community Add-ons"
