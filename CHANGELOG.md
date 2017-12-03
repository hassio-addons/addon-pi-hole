# Community Hass.io Add-ons: Pi-hole

All notable changes to this add-on will be documented in this file.

The format is based on [Keep a Changelog][keep-a-changelog]
and this project adheres to [Semantic Versioning][semantic-versioning].

## Unreleased

No unreleased changes yet.

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
[v0.3.0]: https://github.com/hassio-addons/addon-pi-hole/tree/v0.3.0
