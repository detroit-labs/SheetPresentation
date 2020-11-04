# SheetPresentation

A `UIPresentationController` and attendant clases for iOS to present a view
controller pinned to an edge of the screen like an action sheet.

[![Version](https://img.shields.io/cocoapods/v/SheetPresentation.svg?style=flat)](https://cocoapods.org/pods/SheetPresentation)
[![Documentation](docs/badge.svg)](https://detroit-labs.github.io/SheetPresentation/)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-orange.svg)](https://swift.org/package-manager)
[![License](https://img.shields.io/cocoapods/l/SheetPresentation.svg?style=flat)](https://github.com/detroit-labs/SheetPresentation/blob/master/LICENSE)
![Platform](https://img.shields.io/cocoapods/p/SheetPresentation.svg?style=flat)

# Installation

## Swift Package Manager

To use SheetPresentation with the
[Swift Package Manager](https://swift.org/package-manager/), add it as a
dependency to your project from within Xcode or as a dependency in your
`Package.swift` file. 

## CocoaPods

To use SheetPresentation with [CocoaPods](https://cocoapods.org), add a
dependency to your `Podfile`:

```Ruby
target 'MyAwesomeApp' do
  pod 'SheetPresentation'
end
```

Then run `pod install` and use the generated `.xcworkspace` to open your
project.

## Carthage

To use SheetPresentation with
[Carthage](https://github.com/Carthage/Carthage), add a dependency to your
`Cartfile`:

```
github "Detroit-Labs/SheetPresentation"
```

Run `carthage update` to build the framework. Then follow the rest of the steps
in [Carthage’s README](https://github.com/Carthage/Carthage#getting-started) to
add the framework to your project, configure a Run Script build phase, etc.

# Using SheetPresentation

## Swift

To use SheetPresentation, create a `SheetPresentationManager` and
set it as the `transitioningDelegate` of the view controller you want to
present, then set the `modalPresentationStyle` of the view controller to
`.custom`.

```Swift
let manager = SheetPresentationManager() // Save this reference somewhere
let viewControllerToPresent = …
viewControllerToPresent.transitioningDelegate = manager
viewControllerToPresent.modalPresentationStyle = .custom

present(viewControllerToPresent, animated: true, completion: nil)
```

## Objective-C

SheetPresentation also works with Objective-C:

```Objective-C
SheetPresentationManager *manager = [[SheetPresentationManager alloc] init];

UIViewController *viewControllerToPresent = …;
viewControllerToPresent.transitioningDelegate = manager;
viewControllerToPresent.modalPresentationStyle = UIModalPresentationCustom;

[self presentViewController:viewControllerToPresent
                   animated:YES
                 completion:NULL];
```

## Requirements

To correctly compute the height of the presented view controller, it must either
satisfy Auto Layout constraints for a height using
`systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)` or have a non-zero
`preferredContentSize`.
