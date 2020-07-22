//
//  PresentationLayout.swift
//  SheetPresentation
//
//  Created by Jeff Kelley on 7/14/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import UIKit

/// How the presented view controller should be positioned in the presentation
/// container.
public enum PresentationLayout: Equatable {

    /// Controls where on the screen an automatically-sized view controller is
    /// placed horizontally.
    public enum HorizontalAlignment: Equatable {

        /// Aligns the view to the leading edge of the container.
        case leading

        /// Centers the view horizontally inside the container.
        case center

        /// Aligns the view to the trailing edge of the container.
        case trailing

        /// Aligns the view to the left edge of the container.
        ///
        /// Available for legacy layouts; use of `leading` is preferred.
        case left

        /// Aligns the view to the right edge of the container.
        ///
        /// Available for legacy layouts; use of `trailing` is preferred.
        case right

    }

    /// Controls where on the screen an automatically-sized view controller is
    /// placed vertically.
    public enum VerticalAlignment: Equatable {

        /// Aligns the view to the top edge of the container.
        case top

        /// Centers the view vertically inside the container.
        case middle

        /// Aligns the view to the bottom edge of the container.
        case bottom

    }

    /// Horizontal sizing behavior for the presented view controller.
    public enum HorizontalSizingBehavior: Equatable {

        // swiftlint:disable line_length
        /// Sets the width of the view controller’s view according to the view
        /// controller’s `preferredContentSize`, property, if non-zero, or by
        /// calling
        /// `systemLayoutSizeFitting(_:withHorizontalFittingPriority:verticalFittingPriority:)`
        /// on the presented view controller’s view to determine the appropriate
        /// size.
        case automatic(alignment: HorizontalAlignment)
        // swiftlint:enable line_length

        /// Fills the available space based on `edgeInsets` and
        /// `ignoredEdgesForMargins`.
        case fill

    }

    /// Vertical sizing behavior for the presented view controller.
    public enum VerticalSizingBehavior: Equatable {

        // swiftlint:disable line_length
        /// Sets the height of the view controller’s view according to the view
        /// controller’s `preferredContentSize`, property, if non-zero, or by
        /// calling
        /// `systemLayoutSizeFitting(_:withHorizontalFittingPriority:verticalFittingPriority:)`
        /// on the presented view controller’s view to determine the appropriate
        /// size.
        case automatic(alignment: VerticalAlignment)
        // swiftlint:enable line_length

        /// Fills the available space based on `edgeInsets` and
        /// `ignoredEdgesForMargins`.
        case fill

    }

    /// Places the view controller’s view at the leading edge of the
    /// presentation container, filling the container’s height, using the
    /// specified `HorizontalSizingBehavior` to determine the view’s width and
    /// horizontal position.
    case leading(HorizontalSizingBehavior = .automatic(alignment: .leading))

    /// Places the view controller’s view at the trailing edge of the
    /// presentation container, filling the container’s height, using the
    /// specified `HorizontalSizingBehavior` to determine the view’s width and
    /// horizontal position.
    case trailing(HorizontalSizingBehavior = .automatic(alignment: .trailing))

    /// Places the view controller’s view at the top of the presentation
    /// container, filling the container’s width, and using the specified
    /// `VerticalSizingBehavior` to determine the view’s height and vertical
    /// position.
    case top(VerticalSizingBehavior = .automatic(alignment: .top))

    /// Places the view controller’s view at the bottom of the presentation
    /// container, filling the container’s width, and using the specified
    /// `VerticalSizingBehavior` to determine the view’s height and vertical
    /// position.
    case bottom(VerticalSizingBehavior = .automatic(alignment: .bottom))

    /// Uses the given `HorizontalSizingBehavior` and `VerticalSizingBehavior`
    /// to determine the placement and the size of the presented view
    /// controller’s view.
    case overlay(
        HorizontalSizingBehavior = .fill,
        VerticalSizingBehavior = .fill
    )

    /// Places the view controller’s view at the left edge of the presentation
    /// container, filling the container’s height, using the specified
    /// `HorizontalSizingBehavior` to determine the view’s width and horizontal
    /// position.
    ///
    /// Available for legacy layouts; use of `leading` is preferred.
    case left(HorizontalSizingBehavior = .automatic(alignment: .left))

    /// Places the view controller’s view at the right edge of the presentation
    /// container, filling the container’s height, using the specified
    /// `HorizontalSizingBehavior` to determine the view’s width and horizontal
    /// position.
    ///
    /// Available for legacy layouts; use of `trailing` is preferred.
    case right(HorizontalSizingBehavior = .automatic(alignment: .right))

    /// Calculates the `ViewEdge` used for presentation for a given trait
    /// collection.
    ///
    /// - Parameter traitCollection: The `UITraitCollection` of the presentation
    ///                              environment; pass `nil` to use the
    ///                              defaults.
    /// - Returns: A `ViewEdge` that represents the edge of the screen that the
    ///            layout attaches to, or `nil` where there is no semantic edge.
    func viewEdge(for traitCollection: UITraitCollection? = nil) -> ViewEdge? {
        switch (self, traitCollection?.layoutDirection) {
        case (.leading, _):
            return .leading
        case (.left, .rightToLeft):
            return .trailing
        case (.left, _):
            return .leading
        case (.trailing, _):
            return .trailing
        case (.right, .rightToLeft):
            return .leading
        case (.right, _):
            return .trailing
        case (.top, _):
            return .top
        case (.bottom, _):
            return .bottom
        case (.overlay, _):
            return nil
        }
    }

}
