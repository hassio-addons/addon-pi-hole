#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Pi-hole
# Applies patches to Pi-hole
# ==============================================================================
readonly base=/var/www/html/admin
declare hostname

hostname="hassio"
if bashio::supervisor.ping; then
    hostname=$(bashio::host.hostname)
elif bashio::fs.file_exists '/data/hostname'; then
    hostname=$(</data/hostname)
fi

bashio::log.debug 'Patching Pi-hole for use with Home Assistant...'
sed -i 's/Are you sure you want to send a poweroff command to your Pi-Hole\?/Are you sure you want to send a stop command to your Pi-Hole add-on\?/g' "${base}/scripts/pi-hole/js/settings.js"
sed -i 's/Are you sure you want to send a reboot command to your Pi-Hole\?/Are you sure you want to send a restart command to your Pi-Hole add-on\?/g' "${base}/scripts/pi-hole/js/settings.js"
sed -i 's/Designed For Raspberry Pi/Modified for Home Assistant/g' "${base}/scripts/pi-hole/php/header.php"
sed -i 's/echo -ne/echo -e/g' /opt/pihole/gravity.sh
sed -i 's/Power off system/Stop add-on/g' "${base}/settings.php"
sed -i 's/Restart system/Restart add-on/g' "${base}/settings.php"
sed -i 's/The system will poweroff in 5 seconds.../The add-on will stop in 15 seconds.../g' "${base}/scripts/pi-hole/php/savesettings.php"
sed -i 's/The system will reboot in 5 seconds.../The add-on will restart in 15 seconds.../g' "${base}/scripts/pi-hole/php/savesettings.php"
sed -i 's/Updates/Forums/g' "${base}/scripts/pi-hole/php/header.php"
sed -i 's/Yes, poweroff/Yes, stop/g' "${base}/scripts/pi-hole/js/settings.js"
sed -i 's/Yes, reboot/Yes, restart/g' "${base}/scripts/pi-hole/js/settings.js"
sed -i 's#/etc/hostname#/data/hostname#g' "${base}/settings.php"
sed -i 's#https://github.com/pi-hole/pi-hole/releases#https://community.home-assistant.io/t/home-assistant-community-add-on-pi-hole/33817?u=frenck#g' "${base}/scripts/pi-hole/php/header.php"
sed -i 's#https://github.com/pi-hole#https://github.com/hassio-addons/addon-pi-hole#g' "${base}/scripts/pi-hole/php/header.php"
sed -i 's#sudo pihole -a poweroff#nohup bash -c \\"sudo /usr/bin/stop_addon\\" \&> /dev/null </dev/null \&#g' "${base}/scripts/pi-hole/php/savesettings.php"
sed -i 's#sudo pihole -a reboot#nohup bash -c \\"sudo /usr/bin/restart_addon\\" \&> /dev/null </dev/null \&#g' "${base}/scripts/pi-hole/php/savesettings.php"
sed -i "s/gethostname()/\"${hostname}\"/g" "${base}/scripts/pi-hole/php/header.php"
sed -i "s#\"localhost\"#\"localhost\",\"${hostname}\",\"${hostname}\\.local\"#g" "${base}/scripts/pi-hole/php/auth.php"
sed -i "s#HTTP_ORIGIN#HTTP_BRAINDAMAGE#g" "${base}/scripts/pi-hole/php/auth.php"
sed -i 's#/etc/pihole/logrotate#/etc/logrotate.d/pihole#g' /opt/pihole/piholeLogFlush.sh
