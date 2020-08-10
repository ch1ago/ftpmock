# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).





## [Unreleased]
### Added
- Added CHANGELOG.

### Changed
- Ruby loading - Replacing preload with autoload.

### Deprecated
- .

### Removed
- Gem build - Remove image files.

### Fixed
- NetFtpProxy - #login raises Ftpmock::CodeError if called before #connect.
- Errors - Reparenting an error class.

### Security
- Dependencies - rake 13.





## [0.1.0] - 2020-02-25
### First Release
- Added README Documentation.
- Added README Instructions.
- Added TravisCI & CodeClimate.
- NetFtpProxy - added support for more initializer signatures.
- NetFtpProxy - Adding directions to implement methods.
- Cache#list/get/put - Added Verbose Alerts.
- Cache#put & NetFtpProxy#put.
- Cache#get & NetFtpProxy#get.
- Cache#list & NetFtpProxy#list.
- NetFtpProxy#chdir/pwd/getdir & Cache#chdir.
- Cache & NetFtpProxy connectivity.
- NetFtpProxy#method_missing & Configuration#verbose.
- Basic stubs for gem 'net-sftp'.
- Basic stub of Net::FTP as Ftpmock::NetFtpProxy.
- Rubocop 0.80.0 - February 18, 2020.
- First commit.





## [0.0.0] - 2019-11-01
### Added
- .

### Changed
- .

### Deprecated
- .

### Removed
- .

### Fixed
- .

### Security
- .
