# Feather Mail SES 

Amazon SES-backed mail client for Feather Mail.

[![Release:1.0.0-beta.4](https://img.shields.io/badge/Release-1.0.0--beta.4-F05138)](https://github.com/feather-framework/feather-mail-ses/releases/tag/1.0.0-beta.4)

## Features

- SES v2 delivery via Soto
- MIME message encoding using Feather Mail raw encoder
- Validates mail before delivery
- Supports text, HTML, and attachments

## Requirements

![Swift 6.1+](https://img.shields.io/badge/Swift-6%2E1%2B-F05138)
![Platforms: Linux, macOS, iOS, tvOS, watchOS, visionOS](https://img.shields.io/badge/Platforms-Linux_%7C_macOS_%7C_iOS_%7C_tvOS_%7C_watchOS_%7C_visionOS-F05138)

- Swift 6.1+
- Platforms:
  - Linux
  - macOS 15+
  - iOS 18+
  - tvOS 18+
  - watchOS 11+
  - visionOS 2+

## Installation

Use Swift Package Manager; add the dependency to your `Package.swift` file:

```swift
.package(url: "https://github.com/feather-framework/feather-mail-ses", exact: "1.0.0-beta.4"),
```

Then add `FeatherMailSES` to your target dependencies:

```swift
.product(name: "FeatherMailSES", package: "feather-mail-ses"),
```

## Usage

[![DocC API documentation](https://img.shields.io/badge/DocC-API_documentation-F05138)](https://feather-framework.github.io/feather-mail-ses/)

API documentation is available at the following link.

> [!WARNING]
> This repository is a work in progress, things can break until it reaches v1.0.0.

## Related repositories

- [Feather Mail](https://github.com/feather-framework/feather-mail)
- [Feather Mail SMTP](https://github.com/feather-framework/feather-mail-smtp)
- [Feather Mail Ephemeral](https://github.com/feather-framework/feather-mail-ephemeral)

## Development

- Build: `swift build`
- Test:
  - local: `make test`
  - using Docker: `make docker-test`
- Format: `make format`
- Check: `make check`

## Contributing

[Pull requests](https://github.com/feather-framework/feather-mail-ses/pulls) are welcome. Please keep changes focused and include tests for new logic.
