# BottomSheetPresentation

A `UIPresentationController` and attendant clases for iOS to present a view controller pinned to the bottom of the screen like an action sheet.

[![Version](https://img.shields.io/cocoapods/v/BottomSheetPresentation.svg?style=flat)](https://cocoapods.org/pods/BottomSheetPresentation)
[![Documentation](docs/badge.svg)](https://detroit-labs.github.io/BottomSheetPresentation/)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/BottomSheetPresentation.svg?style=flat)](https://github.com/detroit-labs/BottomSheetPresentation/blob/master/LICENSE)
![Platform](https://img.shields.io/cocoapods/p/BottomSheetPresentation.svg?style=flat)

# Installation

## Swift Package Manager

To use BottomSheetPresentation with the [Swift Package Manager](https://swift.org/package-manager/), add it as a dependency to your project from within Xcode or as a dependency in your `Package.swift` file. 

## CocoaPods

To use BottomSheetPresentation with [CocoaPods](https://cocoapods.org), add a dependency to your `Podfile`:

```Ruby
target 'MyAwesomeApp' do
  pod 'BottomSheetPresentation'
end
```

Then run `pod install` and use the generated `.xcworkspace` to open your project.

## Carthage

To use BottomSheetPresentation with [Carthage](https://github.com/Carthage/Carthage), add a dependency to your `Cartfile`:

```
github "Detroit-Labs/BottomSheetPresentation"
```

Run `carthage update` to build the framework. Then follow the rest of the steps in [Carthage’s README](https://github.com/Carthage/Carthage#getting-started) to add the framework to your project, configure a Run Script build phase, etc.

## Manually

To integrate BottomSheetPresentation manually into your project, drag `BottomSheetPresentation.swift` into your Xcode project.

# Using BottomSheetPresentation

## Swift

To use BottomSheetPresentation, create a `BottomSheetPresentationManager` and set it as the `transitioningDelegate` of the view controller you want to present, then set the `modalPresentationStyle` of the view controller to `.custom`.

```Swift
let manager = BottomSheetPresentationManager() // Save this reference somewhere
let viewControllerToPresent = …
viewControllerToPresent.transitioningDelegate = manager
viewControllerToPresent.modalPresentationStyle = .custom

present(viewControllerToPresent, animated: true, completion: nil)
```

## Objective-C

BottomSheetPresentation also works with Objective-C:

```Objective-C
BottomSheetPresentationManager *manager = [[BottomSheetPresentationManager alloc] init];

UIViewController *viewControllerToPresent = …;
viewControllerToPresent.transitioningDelegate = manager;
viewControllerToPresent.modalPresentationStyle = UIModalPresentationCustom;

[self presentViewController:viewControllerToPresent
                   animated:YES
                 completion:NULL];
```

## Requirements

To correctly compute the height of the presented view controller, it must either satisfy Auto Layout constraints for a height using `systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)` or have a non-zero `preferredContentSize`.
