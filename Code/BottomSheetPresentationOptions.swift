//
//  BottomSheetPresentationOptions.swift
//  BottomSheetPresentation
//
//  Created by Jeff Kelley on 7/17/18.
//  Copyright © 2019 Detroit Labs, LLC. All rights reserved.
//

import UIKit

/// Options for presentation. These options are passed to created
/// `BottomSheetPresentationController` objects upon creation.
public struct BottomSheetPresentationOptions {

    /// The corner radius to use when displaying the presented view controller.
    public let cornerRadius: CGFloat

    /// The corners to mask using the corner radius. Defaults to all four.
    /// Requires iOS 11 to function (on iOS 10 and below, all four corners will
    /// be rounded using the corner radius).
    public let maskedCorners: CACornerMask

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
    public let ignoredEdgesForMargins: UIView.Edge

    /// The default options that are used when calling `init()` on a
    /// `BottomSheetPresentationManager` with no options.
    ///
    /// - SeeAlso:
    ///   - `BottomSheetPresentationOptions.default`
    @available(*, deprecated, renamed: "default")
    public static let defaultOptions: BottomSheetPresentationOptions = .default

    /// The default options that are used when calling `init()` on a
    /// `BottomSheetPresentationManager` with no options.
    public static let `default` = BottomSheetPresentationOptions(
        cornerRadius: 10,
        maskedCorners: .all,
        dimmingViewAlpha: 0.5,
        edgeInsets: UIEdgeInsets(constant: 20),
        ignoredEdgesForMargins: [])

    /// Creates a new `BottomSheetPresentationOptions` struct.
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
                ignoredEdgesForMargins: UIView.Edge = []) {
        self.cornerRadius = cornerRadius
        self.maskedCorners = maskedCorners
        self.dimmingViewAlpha = dimmingViewAlpha
        self.edgeInsets = edgeInsets
        self.ignoredEdgesForMargins = ignoredEdgesForMargins
    }
}

extension BottomSheetPresentationOptions: Equatable {}
