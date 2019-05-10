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

    /// The `alpha` value for the dimming view used behind the presented
    /// view controller. The color is black.
    public let dimmingViewAlpha: CGFloat

    /// The amount to inset the presented view controller from the
    /// presenting view controller. This is a minimum; there may be
    /// additional insets depending on the safe area insets of the
    /// presenting view controller’s view.
    public let edgeInsets: UIEdgeInsets

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
        dimmingViewAlpha: 0.5,
        edgeInsets: UIEdgeInsets(constant: 20))

    /// Creates a new `BottomSheetPresentationOptions` struct.
    ///
    /// - Parameters:
    ///   - cornerRadius: The corner radius to use when displaying the presented
    ///                   view controller. Defaults to `10`.
    ///   - dimmingViewAlpha: The `alpha` value for the dimming view used behind
    ///                       the presented view controller. The color is black.
    ///                       Defaults to `0.5`.
    ///   - edgeInsets: The amount to inset the presented view controller from
    ///                 the presenting view controller. This is a minimum; there
    ///                 may be additional insets depending on the safe area
    ///                 insets of the presenting view controller’s view (iOS 11
    ///                 and later). Defaults to edge insets of `20` points on
    ///                 each side.
    public init(cornerRadius: CGFloat = 10,
                dimmingViewAlpha: CGFloat = 0.5,
                edgeInsets: UIEdgeInsets = UIEdgeInsets(constant: 20)) {
        self.cornerRadius = cornerRadius
        self.dimmingViewAlpha = dimmingViewAlpha
        self.edgeInsets = edgeInsets
    }
}

extension BottomSheetPresentationOptions: Equatable {}
