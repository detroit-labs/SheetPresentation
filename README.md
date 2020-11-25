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

To use SheetPresentation, create a `SheetPresentationManager` and
set it as the [`transitioningDelegate`][1] of the view controller you want to
present, then set the [`modalPresentationStyle`][2] of the view controller to
`.custom`.

```Swift
let manager = SheetPresentationManager() // Save this reference somewhere
let viewControllerToPresent = …
viewControllerToPresent.transitioningDelegate = manager
viewControllerToPresent.modalPresentationStyle = .custom

present(viewControllerToPresent, animated: true, completion: nil)
```

[1]: https://developer.apple.com/documentation/uikit/uiviewcontroller/1621421-transitioningdelegate
[2]: https://developer.apple.com/documentation/uikit/uiviewcontroller/1621355-modalpresentationstyle

## Presentation Options

To get the most out of SheetPresentation, you’ll need to set some options on
your `SheetPresentationManager` instances:

### Corner Options

The corner options specify whether and how the corners of presented views should
have their corners rounded:

- `.roundAllCorners`, which takes a `CGFloat` corner radius, rounds all corners
  with the given radius.
- `.roundSomeCorners`, which takes a `CGFloat` corner radius and a
  [`CACornerMask`][3] to specify which corner(s) should be rounded.
- `.none` leaves the presented view’s corners around.

The default value is `.roundAllCorners` with a radius of 10 points.

[3]: https://developer.apple.com/documentation/quartzcore/cacornermask

### Dimming View Alpha

SheetPresentation can place a black dimming view behind the presented view. To
control its opacity, you can specify a `CGFloat` value. If you specify `nil`,
then a dimming view will not be placed behind the presented view and touches
will be forwarded to the presenting view controller if they fall outside the
presented view.

The default value is 50% opacity.

### Edge Insets

The edge insets control the distance between the presenting view controller and
the presented view. You can use either [`UIEdgeInsets`][4] or
[`NSDirectionalEdgeInsets`][5]. This value is combined with the safe area, so if
you use an inset that is less than the safe area, the safe area’s inset will be
used.

The default value is 20 points on all sides.

[4]: https://developer.apple.com/documentation/uikit/uiedgeinsets
[5]: https://developer.apple.com/documentation/uikit/nsdirectionaledgeinsets

### Ignored Edges for Margins

You can specify an array of edges to ignore for margins (including the safe
area) when performing layout. Edges can be either the `DirectionalViewEdge` or
`FixedViewEdge` type, depending on if you want to use `.leading` and `.trailing`
(recommended) or `.left` and `.right`.

The default value is an empty array to ignore no edges.

### Presentation Layout

The presentation layout controls how SheetPresentation positions the presented
view within the presentation container. Specify both horizontal and vertical
layouts, which can either be `.fill` to fill the container or `.automatic` to
automatically size the presented view. The automatic layouts must specify either
vertical or horizontal alignment to control where the presented view is placed
relative to the container.

The default value is a vertical layout of `.automatic(.bottom)` and a horizontal
layout of `.fill`.

#### Requirements

To correctly compute the height of the presented view controller when using
automatic layouts, it must either satisfy Auto Layout constraints for a height
using
[`systemLayoutSizeFitting(_:withHorizontalFittingPriority:verticalFittingPriority:)`][6]
or have a non-zero [`preferredContentSize`][7].

[6]: https://developer.apple.com/documentation/uikit/uiview/1622623-systemlayoutsizefitting
[7]: https://developer.apple.com/documentation/uikit/uiviewcontroller/1621476-preferredcontentsize

### Animation Behavior

When the presented view controller is presented or dismissed, these options
control the way that this animation occurs. You can use `.system` to use the
default UIKit animations, use `.custom` to provide your own animator objects
that conform to the [`UIViewControllerAnimatedTransitioning`][8] protocol, or
use `.present` to slide the view controller to or from the given view edge(s).

The default value is `.system`.

[8]: https://developer.apple.com/documentation/uikit/uiviewcontrolleranimatedtransitioning