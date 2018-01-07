# Community Hass.io Add-ons: Pi-hole

All notable changes to this add-on will be documented in this file.

The format is based on [Keep a Changelog][keep-a-changelog]
and this project adheres to [Semantic Versioning][semantic-versioning].

## Unreleased

No unreleased changes yet.

## [v0.5.0] (2018-01-07)

[Full Changelog][v0.4.0-v0.5.0]

### Added

- Allows for http & https at the same time #18

### Fixed

- Fixes an issue with Pi-hole and FTL versions displayed as N/A #19
- Typo in container init
- Fixes the enable/disable/clear functions of the query logs #20

### Changed

- Prevents possible future Docker login issue
- Pass local CircleCI Docker socket into the build container
- Use image tagged as test as a cache resource
- Updated maintenance year, it is 2018
- Upgrades add-on base image to v1.3.1
- Upgrades Pi-hole to v3.2.1

### Removed

- Removes Microbadger notification hooks

## [v0.4.0] (2017-12-08)

[Full Changelog][v0.3.0-v0.4.0]

### Added

- Added debug mode to Pi-hole FTL

### Changed

- Upgraded Pi-hole core to v3.2 #13
- Upgraded Pi-hole AdminLTE to v3.2 #13
- Upgraded Pi-hole FTL to v2.12 #13
- Fixed typo in panel_iframe example config in the README #16

### Removed

- Removed unused detect_ftl_binary.sh script

## [v0.3.0] (2017-12-03)

[Full Changelog][v0.2.1-v0.3.0]

### Added

- Support for configuring and resolving custom domains #9 #11

### Changed

- Upgrades add-on base image to v1.2.0
- Updates add-on URLs to new community forum URL
- Moves copy of rootfs at a later stage

## [v0.2.1] (2017-11-29)

[Full Changelog][v0.2.0-v0.2.1]

### Changed

- Removal of X-Frame-Options header to avoid embedding issues with SSL #10
- Changed forums link in README
- Upgraded project stage from "experimental" into "development"

## [v0.2.0] (2017-11-24)

[Full Changelog][v0.1.1-v0.2.0]

### Added

- SSL requirements check on add-on startup

### Changed

- Upgraded base image to v1.1.0

### Fixed

- Not using virtual host #6
- Can't remove blacklisted domains #7

### Removed

- Custom `list.sh`. Now using Pi-holes original version.
- `services` script, which is now provided by the base image

## [v0.1.1] (2017-11-14)

[Full Changelog][v0.1.0-v0.1.1]

### Fixed

- Incorrect URL in "Open Web UI" button #1
- Addon fails to start when IPv6 is not present on network #3
- Visiting blocked page with port number does not redirect to admin #2

## [v0.1.0] (2017-11-12)

### Added

- Initial release

[keep-a-changelog]: http://keepachangelog.com/en/1.0.0/
[semantic-versioning]: http://semver.org/spec/v2.0.0.html
[v0.1.0-v0.1.1]: https://github.com/hassio-addons/addon-pi-hole/compare/v0.1.0...v0.1.1
[v0.1.0]: https://github.com/hassio-addons/addon-pi-hole/tree/v0.1.0
[v0.1.1-v0.2.0]: https://github.com/hassio-addons/addon-pi-hole/compare/v0.1.1...v0.2.0
[v0.1.1]: https://github.com/hassio-addons/addon-pi-hole/tree/v0.1.1
[v0.2.0-v0.2.1]: https://github.com/hassio-addons/addon-pi-hole/compare/v0.2.0...v0.2.1
[v0.2.0]: https://github.com/hassio-addons/addon-pi-hole/tree/v0.2.0
[v0.2.1-v0.3.0]: https://github.com/hassio-addons/addon-pi-hole/compare/v0.2.1...v0.3.0
[v0.2.1]: https://github.com/hassio-addons/addon-pi-hole/tree/v0.2.1
[v0.3.0-v0.4.0]: https://github.com/hassio-addons/addon-pi-hole/compare/v0.3.0...v0.4.0
[v0.3.0]: https://github.com/hassio-addons/addon-pi-hole/tree/v0.3.0
[v0.4.0-v0.5.0]: https://github.com/hassio-addons/addon-pi-hole/compare/v0.4.0...v0.5.0
[v0.4.0]: https://github.com/hassio-addons/addon-pi-hole/tree/v0.4.0
[v0.5.0]: https://github.com/hassio-addons/addon-pi-hole/tree/v0.5.0
