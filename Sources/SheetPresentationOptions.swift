//
//  BottomSheetPresentationOptions.swift
//  BottomSheetPresentation
//
//  Created by Jeff Kelley on 7/17/18.
//  Copyright © 2020 Detroit Labs, LLC. All rights reserved.
//

import UIKit

#if SWIFT_PACKAGE
import BottomSheetPresentationLegacySupport
#endif

/// Options for presentation. These options are passed to created
/// `BottomSheetPresentationController` objects upon creation.
public struct SheetPresentationOptions {

    /// Options for the corners of the presented view controller.
    public enum CornerOptions: Equatable {

        /// Rounds all corners by the given `radius`.
        case roundAllCorners(radius: CGFloat)

        /// Rounds the corners specified in `corners` by the given `radius`.
        case roundSomeCorners(radius: CGFloat, corners: CACornerMask)

        /// Does not round corners.
        case none
    }

    /// The corner radius (or lack thereof) to use when displaying the presented
    /// view controller.
    public let cornerOptions: CornerOptions

    /// The `alpha` value for the dimming view used behind the presented
    /// view controller. The color is black. Use `nil` to avoid adding a dimming
    /// view behind the presented view controller.
    public let dimmingViewAlpha: CGFloat?

    /// The amount to inset the presented view controller from the
    /// presenting view controller. This is a minimum; there may be
    /// additional insets depending on the safe area insets and margins of the
    /// presenting view controller’s view. Use `ignoredEdgesForMargins` to
    /// customize the margin behavior for each edge.
    public let edgeInsets: UIEdgeInsets

    /// Edges of the presenting view controller’s view for which its margins
    /// should be ignored for layout purposes. On iOS 11 and above, this
    /// includes the safe area.
    ///
    /// - SeeAlso: `BSPViewEdge`
    public let ignoredEdgesForMargins: ViewEdge

    /// The default options that are used when calling `init()` on a
    /// `BottomSheetPresentationManager` with no options.
    public static let `default` = SheetPresentationOptions(
        cornerRadius: 10,
        dimmingViewAlpha: 0.5,
        edgeInsets: UIEdgeInsets(constant: 20),
        ignoredEdgesForMargins: [])

    /// Creates a new `BottomSheetPresentationOptions` struct.
    ///
    /// - Parameters:
    ///   - dimmingViewAlpha: The `alpha` value for the dimming view used behind
    ///                       the presented view controller. The color is black.
    ///                       Defaults to `0.5`. Use `nil` to avoid using a
    ///                       dimming view.
    ///   - edgeInsets: The amount to inset the presented view controller from
    ///                 the presenting view controller. This is a minimum; there
    ///                 may be additional insets depending on the safe area
    ///                 insets of the presenting view controller’s view (iOS 11
    ///                 and later). Defaults to edge insets of `20` points on
    ///                 each side.
    ///   - ignoredEdgesForMargins: Edges of the presenting view controller’s
    ///                             view for which its margins should be ignored
    ///                             for layout purposes. On iOS 11 and above,
    ///                             this includes the safe area.
    public init(dimmingViewAlpha: CGFloat? = 0.5,
                edgeInsets: UIEdgeInsets = UIEdgeInsets(constant: 20),
                ignoredEdgesForMargins: ViewEdge = []) {
        self.cornerOptions = .none
        self.dimmingViewAlpha = dimmingViewAlpha
        self.edgeInsets = edgeInsets
        self.ignoredEdgesForMargins = ignoredEdgesForMargins
    }

    /// Creates a new `BottomSheetPresentationOptions` struct with rounded
    /// corners.
    ///
    /// - Parameters:
    ///   - cornerRadius: The corner radius to use when displaying the presented
    ///                   view controller. Defaults to `10`.
    ///   - dimmingViewAlpha: The `alpha` value for the dimming view used behind
    ///                       the presented view controller. The color is black.
    ///                       Defaults to `0.5`. Use `nil` to avoid using a
    ///                       dimming view.
    ///   - edgeInsets: The amount to inset the presented view controller from
    ///                 the presenting view controller. This is a minimum; there
    ///                 may be additional insets depending on the safe area
    ///                 insets of the presenting view controller’s view (iOS 11
    ///                 and later). Defaults to edge insets of `20` points on
    ///                 each side.
    ///   - ignoredEdgesForMargins: Edges of the presenting view controller’s
    ///                             view for which its margins should be ignored
    ///                             for layout purposes. On iOS 11 and above,
    ///                             this includes the safe area.
    public init(cornerRadius: CGFloat = 10,
                dimmingViewAlpha: CGFloat? = 0.5,
                edgeInsets: UIEdgeInsets = UIEdgeInsets(constant: 20),
                ignoredEdgesForMargins: ViewEdge = []) {
        self.cornerOptions = .roundAllCorners(radius: cornerRadius)
        self.dimmingViewAlpha = dimmingViewAlpha
        self.edgeInsets = edgeInsets
        self.ignoredEdgesForMargins = ignoredEdgesForMargins
    }

    /// Creates a new `BottomSheetPresentationOptions` struct with some rounded
    /// corners.
    ///
    /// - Parameters:
    ///   - cornerRadius: The corner radius to use when displaying the presented
    ///                   view controller. Defaults to `10`.
    ///   - maskedCorners: The corners to mask using the `cornerRadius`.
    ///   - dimmingViewAlpha: The `alpha` value for the dimming view used behind
    ///                       the presented view controller. The color is black.
    ///                       Defaults to `0.5`. Use `nil` to avoid using a
    ///                       dimming view.
    ///   - edgeInsets: The amount to inset the presented view controller from
    ///                 the presenting view controller. This is a minimum; there
    ///                 may be additional insets depending on the safe area
    ///                 insets of the presenting view controller’s view (iOS 11
    ///                 and later). Defaults to edge insets of `20` points on
    ///                 each side.
    ///   - ignoredEdgesForMargins: Edges of the presenting view controller’s
    ///                             view for which its margins should be ignored
    ///                             for layout purposes. On iOS 11 and above,
    ///                             this includes the safe area.
    public init(cornerRadius: CGFloat = 10,
                maskedCorners: CACornerMask = .all,
                dimmingViewAlpha: CGFloat? = 0.5,
                edgeInsets: UIEdgeInsets = UIEdgeInsets(constant: 20),
                ignoredEdgesForMargins: ViewEdge = []) {
        self.cornerOptions = .roundSomeCorners(radius: cornerRadius,
                                               corners: maskedCorners)
        self.dimmingViewAlpha = dimmingViewAlpha
        self.edgeInsets = edgeInsets
        self.ignoredEdgesForMargins = ignoredEdgesForMargins
    }

}

extension SheetPresentationOptions: Equatable {}

extension SheetPresentationOptions.CornerOptions {

    func apply(to view: UIView) {
        switch self {
        case .roundAllCorners(radius: let radius):
            view.layer.cornerRadius = radius
            view.clipsToBounds = true
            view.layer.maskedCorners = .all

        case let .roundSomeCorners(radius: radius, corners: corners):
            view.layer.cornerRadius = radius
            view.clipsToBounds = true
            view.layer.maskedCorners = corners

        case .none:
            view.layer.cornerRadius = 0
            view.clipsToBounds = false
        }
    }

}
