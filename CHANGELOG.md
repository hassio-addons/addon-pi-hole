# Community Hass.io Add-ons: Pi-hole

All notable changes to this add-on will be documented in this file.

The format is based on [Keep a Changelog][keep-a-changelog]
and this project adheres to [Semantic Versioning][semantic-versioning].

## Unreleased

No unreleased changes yet.

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
[v0.2.0]: https://github.com/hassio-addons/addon-pi-hole/tree/v0.2.0
