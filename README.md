# Community Hass.io Add-ons: Pi-hole

[![GitHub Release][releases-shield]][releases]
![Project Stage][project-stage-shield]
![Project Maintenance][maintenance-shield]
[![GitHub Activity][commits-shield]][commits]
[![License][license-shield]](LICENSE.md)

[![CircleCI][circleci-shield]][circleci]
[![Code Climate][codeclimate-shield]][codeclimate]
[![Bountysource][bountysource-shield]][bountysource]
[![Discord][discord-shield]][discord]
[![Community Forum][forum-shield]][forum]

[![Patreon][patreon-shield]][patreon]
[![PayPal][paypal-shield]][paypal]
[![Bitcoin][bitcoin-shield]][bitcoin]

Network-wide ad blocking using your Hass.io instance

## About

[Pi-hole][pi-hole] is an advertising-aware DNS- and web server, meant to be run
on a dedicated Raspberry Pi connected to your home network. Pi-hole lets you
block advertisements for every device that connects to your network without the
need for any client-side software.

This add-on is a port of Pi-hole to be able to run on Hass.io and is based on
Alpine Linux and is using Docker.

## Installation

The installation of this add-on is pretty straightforward and not different in
comparison to installing any other Hass.io add-on.

1. [Add our Hass.io add-ons repository][repository] to your Hass.io instance.
1. Install the "Pi-hole" add-on
1. Start the "Pi-hole" add-on
1. Check the logs of the "Pi-hole" add-on to see it in action.

**NOTE**: Do not add this repository to Hass.io, please use:
`https://github.com/hassio-addons/repository`.

## Docker status

[![Docker Architecture][armhf-arch-shield]][armhf-dockerhub]
[![Docker Version][armhf-version-shield]][armhf-microbadger]
[![Docker Layers][armhf-layers-shield]][armhf-microbadger]
[![Docker Pulls][armhf-pulls-shield]][armhf-dockerhub]

[![Docker Architecture][aarch64-arch-shield]][aarch64-dockerhub]
[![Docker Version][aarch64-version-shield]][aarch64-microbadger]
[![Docker Layers][aarch64-layers-shield]][aarch64-microbadger]
[![Docker Pulls][aarch64-pulls-shield]][aarch64-dockerhub]

[![Docker Architecture][amd64-arch-shield]][amd64-dockerhub]
[![Docker Version][amd64-version-shield]][amd64-microbadger]
[![Docker Layers][amd64-layers-shield]][amd64-microbadger]
[![Docker Pulls][amd64-pulls-shield]][amd64-dockerhub]

[![Docker Architecture][i386-arch-shield]][i386-dockerhub]
[![Docker Version][i386-version-shield]][i386-microbadger]
[![Docker Layers][i386-layers-shield]][i386-microbadger]
[![Docker Pulls][i386-pulls-shield]][i386-dockerhub]

## Configuration

**Note**: _Remember to restart the add-on when the configuration is changed._

Example add-on configuration:

```json
{
  "log_level": "info",
  "password": "changeme",
  "update_lists_on_start": true,
  "web_port": 80,
  "dns_port": 53,
  "ssl": false,
  "certfile": "fullchain.pem",
  "keyfile": "privkey.pem",
  "interface": "eth0",
  "ipv6": true,
  "ipv4_address": "",
  "ipv6_address": "",
  "virtual_host": "homeassistant.example.com",
  "hosts": [
    {
      "name": "printer.local",
      "ip": "192.168.1.5"
    },
    {
      "name": "router.local",
      "ip": "192.168.1.1"
    },
    {
      "name": "router.local",
      "ip": "FE80:0000:0000:0000:0202:B3FF:FE1E:8329"
    }
  ]
}
```

**Note**: _This is just an example, don't copy and past it! Create your own!_

### Option: `log_level`

The `log_level` option controls the level of log output by the addon and can
be changed to be more or less verbose, which might be useful when you are
dealing with an unknown issue. Possible values are:

- `trace`: Show every detail, like all called internal functions.
- `debug`: Shows detailed debug information.
- `info`: Normal (usually) interesting events.
- `warning`: Exceptional occurrences that are not errors.
- `error`:  Runtime errors that do not require immediate action.
- `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a
more severe level, e.g., `debug` also shows `info` messages. By default,
the `log_level` is set to `info`, which is the recommended setting unless
you are troubleshooting.

Using `trace` or `debug` log levels puts the dnsmasq daemon into debug mode,
allowing you to see all DNS requests in the add-on log.

### Option: `password`

Sets the password to authenticate with the Pi-hole web interface. Leaving it
empty disables the possibility to authenticate completely.

**Note**: Be aware! Even when you have set a password, some statistics are
still visible / available.

### Option: `update_lists_on_start`

Download and process all configured ad block lists on add-on startup by setting
this option to `true`. This will add startup time to your add-on but will give
you the most recent versions of the ad block lists on start.

When this option is set to `false` you will still get updated lists once in a
while. A scheduled task will take care of that.

**Note**: _When starting the add-on for the very first time, the lists will be
updated, regardless of the value of this option._

### Option: `web_port`

Changes the port on which the Pi-hole web interface and the blocked page
will be served from.

**Note**: Port `80` is highly recommended because if you have another service
using port `80`, then the ads may not transform into blank ads correctly.

### Option: `dns_port`

Allows you to change the DNS port. `53` is the default port for DNS. Unless you
have a good reason to change it, leave it to `53`.

### Option: `ssl`

Enables/Disables SSL (HTTPS) on the web interface of Pi-hole. Set it `true` to
enable it, `false` otherwise.

**Note**: Enabling SSL on Pi-hole may have side effects, which may cause ads
not to transform into blank ads correctly.

### Option: `certfile`

The certificate file to use for SSL.

**Note**: _The file MUST be stored in `/ssl/`, which is default for Hass.io_

### Option: `keyfile`

The private key file to use for SSL.

**Note**: _The file MUST be stored in `/ssl/`, which is default for Hass.io_

### Option: `interface`

Configures the interface the Pi-hole DNS server should be listening to. By
leaving it empty, the add-on will try to auto-detect the interface to use.

**Note**: _This option is in place in case auto-detection fails on your setup._

### Option: `ipv6`

Set this option to `false` to disable IPv6 support.

### Option: `ipv4_address`

Manually set the IPv4 address for Pi-hole to use. By leaving it empty, the
add-on will try to auto-detect the interface to use.

**Note**: _This option is in place in case auto-detection fails on your setup._

### Option: `ipv6_address`

Manually set the IPv6 address for Pi-hole to use. By leaving it empty, the
add-on will try to auto-detect the interface to use.

**Note**: _This option is in place in case auto-detection fails on your setup._

### Option: `virtual_host`

In case you have an alternative hostname to access Pi-hole (e.g., DuckDNS), you
can specify it in this option. This improves the handling of the Pi-hole
blocked website & admin web interface pages.

### Option: `hosts`

This option allows you create your own DNS entries for your LAN. This
capability can be handy for pointing easy to remember hostnames to an IP
(e.g., point `printer.local` to the IP address of your printer).

Add a list of hosts you want to add. Some hosts can have both IPv4 and IPv6
addresses. In that case, simply add the host twice (with both addresses).

See the example above this chapter for a more visual representation.

#### Sub-option: `name`

This option specifies the DNS name of the host you are adding. Its value could
be a short style hostname like: `printer` or a longer one `printer.local`.

#### Sub-option: `ip`

The IP address this specified host must point to. Its value must be an IPv6 or
IPv4 IP address.

## Embedding into Home Assistant

It is possible to embed the Pi-hole admin directly into Home Assistant, allowing
you to access your terminal through the Home Assistant frontend.

Home Assistant provides the `panel_iframe` component, for these purposes.

Example configuration:

```yaml
panel_iframe:
  terminal:
    title: Pi-hole
    icon: mdi:block-helper
    url: http://addres.to.your.hass.io/admin/index.php
```

## Using the Pi-hole sensor in Home Assistant

Home Assistant offers a [Pi-hole sensor][pi-hole-sensor] that allows you to
display the statistical summary of your Pi-hole installation.

To enable this sensor, add the following lines to your `configuration.yaml`
file:

```yaml
# Example configuration.yaml entry
sensor:
  - platform: pi_hole
```

For more information and documentation about configuring this sensor, please
check the [documentation of Home Assistant][pi-hole-sensor].

## Changelog & Releases

This repository keeps a [change log](CHANGELOG.md). The format of the log
is based on [Keep a Changelog][keepchangelog].

Releases are based on [Semantic Versioning][semver], and use the format
of ``MAJOR.MINOR.PATCH``. In a nutshell, the version will be incremented
based on the following:

- ``MAJOR``: Incompatible or major changes.
- ``MINOR``: Backwards-compatible new features and enhancements.
- ``PATCH``: Backwards-compatible bugfixes and package updates.

## Support

Got questions?

You have several options to get them answered:

- The Home Assistant [Community Forum][forum], we have a
  [dedicated topic][forum] on that forum regarding this add-on.
- The Home Assistant [Discord Chat Server][discord] for general Home Assistant
  discussions and questions.
- Join the [Reddit subreddit][reddit] in [/r/homeassistant][reddit]

You could also [open an issue here][issue] GitHub.

## Contributing

This is an active open-source project. We are always open to people who want to
use the code or contribute to it.

We have set up a separate document containing our
[contribution guidelines](CONTRIBUTING.md).

Thank you for being involved! :heart_eyes:

## Authors & contributors

The original setup of this repository is by [Franck Nijhof][frenck].

For a full list of all authors and contributors,
check [the contributor's page][contributors].

## We have got some Hass.io add-ons for you

Want some more functionality to your Hass.io Home Assistant instance?

We have created multiple add-ons for Hass.io. For a full list, check out
our [GitHub Repository][repository].

## License

MIT License

Copyright (c) 2017 Franck Nijhof

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[aarch64-arch-shield]: https://img.shields.io/badge/architecture-aarch64-blue.svg
[aarch64-dockerhub]: https://hub.docker.com/r/hassioaddons/pi-hole-aarch64
[aarch64-layers-shield]: https://images.microbadger.com/badges/image/hassioaddons/pi-hole-aarch64.svg
[aarch64-microbadger]: https://microbadger.com/images/hassioaddons/pi-hole-aarch64
[aarch64-pulls-shield]: https://img.shields.io/docker/pulls/hassioaddons/pi-hole-aarch64.svg
[aarch64-version-shield]: https://images.microbadger.com/badges/version/hassioaddons/pi-hole-aarch64.svg
[amd64-arch-shield]: https://img.shields.io/badge/architecture-amd64-blue.svg
[amd64-dockerhub]: https://hub.docker.com/r/hassioaddons/pi-hole-amd64
[amd64-layers-shield]: https://images.microbadger.com/badges/image/hassioaddons/pi-hole-amd64.svg
[amd64-microbadger]: https://microbadger.com/images/hassioaddons/pi-hole-amd64
[amd64-pulls-shield]: https://img.shields.io/docker/pulls/hassioaddons/pi-hole-amd64.svg
[amd64-version-shield]: https://images.microbadger.com/badges/version/hassioaddons/pi-hole-amd64.svg
[armhf-arch-shield]: https://img.shields.io/badge/architecture-armhf-blue.svg
[armhf-dockerhub]: https://hub.docker.com/r/hassioaddons/pi-hole-armhf
[armhf-layers-shield]: https://images.microbadger.com/badges/image/hassioaddons/pi-hole-armhf.svg
[armhf-microbadger]: https://microbadger.com/images/hassioaddons/pi-hole-armhf
[armhf-pulls-shield]: https://img.shields.io/docker/pulls/hassioaddons/pi-hole-armhf.svg
[armhf-version-shield]: https://images.microbadger.com/badges/version/hassioaddons/pi-hole-armhf.svg
[bitcoin-shield]: https://img.shields.io/badge/donate-bitcoin-blue.svg
[bitcoin]: https://blockchain.info/payment_request?address=3GVzgN6NpVtfXnyg5dQnaujtqVTEDBCtAH
[bountysource-shield]: https://img.shields.io/bountysource/team/hassio-addons/activity.svg
[bountysource]: https://www.bountysource.com/teams/hassio-addons/issues
[circleci-shield]: https://img.shields.io/circleci/project/github/hassio-addons/addon-pi-hole.svg
[circleci]: https://circleci.com/gh/hassio-addons/addon-pi-hole
[codeclimate-shield]: https://img.shields.io/badge/code%20climate-protected-brightgreen.svg
[codeclimate]: https://codeclimate.com/github/hassio-addons/addon-pi-hole
[commits-shield]: https://img.shields.io/github/commit-activity/y/hassio-addons/addon-pi-hole.svg
[commits]: https://github.com/hassio-addons/addon-pi-hole/commits/master
[contributors]: https://github.com/hassio-addons/addon-pi-hole/graphs/contributors
[discord-shield]: https://img.shields.io/discord/330944238910963714.svg
[discord]: https://discord.gg/c5DvZ4e
[forum-shield]: https://img.shields.io/badge/community-forum-brightgreen.svg
[forum]: https://community.home-assistant.io/t/community-hass-io-add-on-pi-hole/33817?u=frenck
[frenck]: https://github.com/frenck
[i386-arch-shield]: https://img.shields.io/badge/architecture-i386-blue.svg
[i386-dockerhub]: https://hub.docker.com/r/hassioaddons/pi-hole-i386
[i386-layers-shield]: https://images.microbadger.com/badges/image/hassioaddons/pi-hole-i386.svg
[i386-microbadger]: https://microbadger.com/images/hassioaddons/pi-hole-i386
[i386-pulls-shield]: https://img.shields.io/docker/pulls/hassioaddons/pi-hole-i386.svg
[i386-version-shield]: https://images.microbadger.com/badges/version/hassioaddons/pi-hole-i386.svg
[issue]: https://github.com/hassio-addons/addon-pi-hole/issues
[keepchangelog]: http://keepachangelog.com/en/1.0.0/
[license-shield]: https://img.shields.io/github/license/hassio-addons/addon-pi-hole.svg
[maintenance-shield]: https://img.shields.io/maintenance/yes/2017.svg
[patreon-shield]: https://img.shields.io/badge/donate-patreon-blue.svg
[patreon]: https://www.patreon.com/frenck
[paypal-shield]: https://img.shields.io/badge/donate-paypal-blue.svg
[paypal]: https://www.paypal.me/FranckNijhof
[pi-hole-sensor]: https://home-assistant.io/components/sensor.pi_hole/
[pi-hole]: https://pi-hole.net/
[project-stage-shield]: https://img.shields.io/badge/project%20stage-development-yellowgreen.svg
[reddit]: https://reddit.com/r/homeassistant
[releases-shield]: https://img.shields.io/github/release/hassio-addons/addon-pi-hole.svg
[releases]: https://github.com/hassio-addons/addon-pi-hole/releases
[repository]: https://github.com/hassio-addons/repository
[semver]: http://semver.org/spec/v2.0.0.html