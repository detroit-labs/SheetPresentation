fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
### increment_all_build_numbers
```
fastlane increment_all_build_numbers
```
Updates the project build number in the main project and in the examples.
### increment_all_version_numbers
```
fastlane increment_all_version_numbers
```
Updates the project version number in the main project and its examples. Specify a `bump_type` of `major`, `minor`, or `patch` (the default).
### documentation
```
fastlane documentation
```
Generates documentation.

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
