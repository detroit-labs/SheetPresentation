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
public struct PresentationLayout: Equatable {

    /// Controls where on the screen an automatically-sized view controller is
    /// placed horizontally.
    public enum HorizontalAlignment: Equatable, CaseIterable {

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
    public enum VerticalAlignment: Equatable, CaseIterable {

        /// Aligns the view to the top edge of the container.
        case top

        /// Centers the view vertically inside the container.
        case middle

        /// Aligns the view to the bottom edge of the container.
        case bottom

    }

    /// Horizontal sizing behavior for the presented view controller.
    public enum HorizontalLayout: Equatable {

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
    public enum VerticalLayout: Equatable {

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

    /// How the presented view controller should be laid out horizontally.
    public let horizontalLayout: HorizontalLayout

    /// How the presented view controller should be laid out vertically.
    public let verticalLayout: VerticalLayout

    /// Creates a `PresentationLayout` with the given horizontal and vertical
    /// layouts.
    /// - Parameters:
    ///   - horizontalLayout: The horizontal layout to use.
    ///   - verticalLayout: The vertical layout to use.
    public init(horizontalLayout: HorizontalLayout,
                verticalLayout: VerticalLayout) {
        self.horizontalLayout = horizontalLayout
        self.verticalLayout = verticalLayout
    }

    /// The default `PresentationLayout`, which fills the width of the parent
    /// view controller and aligns the presented view controller to the bottom
    /// of the screen.
    public static let `default` = PresentationLayout(
        horizontalLayout: .fill,
        verticalLayout: .automatic(alignment: .bottom)
    )

}
