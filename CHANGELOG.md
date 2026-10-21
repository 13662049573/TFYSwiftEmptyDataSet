# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.2.0] - 2026-10-21

### Changed

- Raised minimum deployment target to **iOS 16.0** across CocoaPods (`TFYSwiftEmptyDataSetKit.podspec`), Swift Package Manager (`Package.swift`), and the Xcode project.
- Removed redundant `@available(iOS 13.0, *)` annotations from the sample app delegates now that iOS 16 is required.
- Simplified UI test launch performance measurement (no legacy availability guard).

### Notes

- Apps or libraries that must support iOS 15 or earlier should stay on **2.1.5**.

## [2.1.5] - (prior release)

- Previous stable release; supports iOS 15+ (SPM) / iOS 13+ (CocoaPods).

[2.2.0]: https://github.com/13662049573/TFYSwiftEmptyDataSet/compare/2.1.5...2.2.0
