//
//  SheetPresentationOptions.swift
//  SheetPresentation
//
//  Created by Jeff Kelley on 7/17/18.
//  Copyright © 2020 Detroit Labs, LLC. All rights reserved.
//

import UIKit

/// Options for presentation. These options are passed to created
/// `SheetPresentationController` objects upon creation.
public struct SheetPresentationOptions {

    /// Options for the corners of the presented view controller.
    public enum CornerOptions: Equatable {

        /// Rounds all corners by the given `radius`.
        case roundAllCorners(radius: CGFloat)

        /// Rounds the corners specified in `corners` by the given `radius`.
        @available(iOS 11.0, macCatalyst 10.15, *)
        case roundSomeCorners(radius: CGFloat, corners: CACornerMask)

        /// Does not round corners.
        case none
    }

    /// The corner radius options to apply to the presented view controller.
    public let cornerOptions: CornerOptions

    /// The `alpha` value for the dimming view used behind the presented
    /// view controller. The color is black. Use `nil` to avoid adding a dimming
    /// view behind the presented view controller.
    public let dimmingViewAlpha: CGFloat?

    /// The amount to inset the presented view controller from the presentation
    /// container. This is a minimum; there may be additional insets depending
    /// on the safe area insets and margins of the container. Use
    /// `ignoredEdgesForMargins` to customize the margin behavior for each edge.
    public let edgeInsets: DirectionalEdgeInsetsConvertible

    /// Edges of the presentation container view for which its margins should be
    /// ignored for layout purposes, including the safe area.
    public let ignoredEdgesForMargins: [ViewEdgeConvertible]

    /// The location to place the presented view controller’s view in the
    /// presentation container.
    public let presentationLayout: PresentationLayout

    /// The animation behavior to use when the presented view controller is
    /// appearing or being dismissed.
    public let animationBehavior: AnimationBehavior

    /// The default options that are used when calling `init()` on a
    /// `SheetPresentationManager` with no options.
    public static let `default` = SheetPresentationOptions()

    /// Creates a value with provided `CornerOptions`.
    ///
    /// - Parameters:
    ///   - cornerOptions: `CornerOptions` to use.
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
    ///                             for layout purposes, including the safe
    ///                             area.
    ///   - presentationEdge: Edge of the screen from which to present. Defaults
    ///                       to `.bottom`.
    ///   - animationBehavior: The way that the presentation animates the
    ///                        appearance and dismissal of the presented view
    ///                        controller.
    public init(
        cornerOptions: CornerOptions = .roundAllCorners(radius: 10),
        dimmingViewAlpha: CGFloat? = 0.5,
        edgeInsets: DirectionalEdgeInsetsConvertible = constantInsets(20),
        ignoredEdgesForMargins: [ViewEdgeConvertible] = [],
        presentationLayout: PresentationLayout = .default,
        animationBehavior: AnimationBehavior = .system
    ) {
        self.cornerOptions = cornerOptions
        self.dimmingViewAlpha = dimmingViewAlpha
        self.edgeInsets = edgeInsets
        self.ignoredEdgesForMargins = ignoredEdgesForMargins
        self.presentationLayout = presentationLayout
        self.animationBehavior = animationBehavior
    }

}

extension SheetPresentationOptions.CornerOptions {

    func apply(to view: UIView) {
        switch self {
        case .roundAllCorners(radius: let radius):
            view.layer.cornerRadius = radius
            view.clipsToBounds = true

            if #available(iOS 11.0, macCatalyst 10.15, *) {
                view.layer.maskedCorners = .all
            }

        case let .roundSomeCorners(radius: radius, corners: corners):
            view.layer.cornerRadius = radius
            view.clipsToBounds = true

            if #available(iOS 11.0, macCatalyst 10.15, *) {
                view.layer.maskedCorners = corners
            }

        case .none:
            view.layer.cornerRadius = 0
            view.clipsToBounds = false
        }
    }

}
