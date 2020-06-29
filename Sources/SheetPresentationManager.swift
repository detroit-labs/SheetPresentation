//
//  SheetPresentationManager.swift
//  SheetPresentation
//
//  Created by Jeff Kelley on 5/10/19.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

// swiftlint:disable file_length

import UIKit

/// A handler that the presentation controller calls when the user taps on the
/// dimming view.
public enum DimmingViewTapHandler {

    /// A block to call when the view is tapped. The parameter passed in to it
    /// will be the presented view controller.
    case block((UIViewController) -> Void)

    /// A target/action pair to call when the view is tapped. The action should
    /// allow for a `sender:` parameter, which will be the presented view
    /// controller.
    case targetAction(NSObjectProtocol, Selector)

    /// The default handler, which will dismiss the presented view controller
    /// upon tapping.
    public static let `default` = DimmingViewTapHandler.block({
        $0.dismiss(animated: true, completion: nil)}
    )

}

/// An object that creates instances of `SheetPresentationController` when
/// set as a view controller’s `transitioningDelegate`.
@objcMembers public final class SheetPresentationManager: NSObject {

    internal let presentationOptions: SheetPresentationOptions
    internal let dimmingViewTapHandler: DimmingViewTapHandler

    /// Creates a `SheetPresentationManager` with specific presentation
    /// options and tap handler.
    ///
    /// - Parameters:
    ///     - options: The options to use for presenting view controllers.
    ///     - dimmingViewTapHandler: A handler to be called when tapping the
    ///                              dimming view.
    public init(
        options: SheetPresentationOptions = .default,
        dimmingViewTapHandler: DimmingViewTapHandler = .default
        ) {
        presentationOptions = options
        self.dimmingViewTapHandler = dimmingViewTapHandler
    }

    /// Creates a `SheetPresentationManager` with specific presentation
    /// options and the default tap handler.
    ///
    /// - Parameters:
    ///     - dimmingViewAlpha: The `alpha` value for the dimming view used
    ///                         behind the presented view controller. The color
    ///                         is black. Use `nil` to avoid using a dimmming
    ///                         view.
    ///     - edgeInsets: The amount to inset the presented view controller from
    ///                   the presenting view controller. This is a minimum;
    ///                   there may be additional insets depending on the safe
    ///                   area insets of the presenting view controller’s view.
    ///     - ignoredEdgesForMargins: Edges of the presenting view controller’s
    ///                               view for which its margins should be
    ///                               ignored for layout purposes.
    public convenience init(dimmingViewAlpha: CGFloat?,
                            edgeInsets: UIEdgeInsets,
                            ignoredEdgesForMargins: ViewEdge = []) {
        let options = SheetPresentationOptions(
            dimmingViewAlpha: dimmingViewAlpha,
            edgeInsets: edgeInsets,
            ignoredEdgesForMargins: ignoredEdgesForMargins)

        self.init(options: options)
    }

    /// Creates a `SheetPresentationManager` with specific presentation
    /// options and the default tap handler.
    ///
    /// - Parameters:
    ///     - cornerRadius: The corner radius to use when displaying the
    ///                     presented view controller.
    ///     - dimmingViewAlpha: The `alpha` value for the dimming view used
    ///                         behind the presented view controller. The color
    ///                         is black. Use `nil` to avoid using a dimmming
    ///                         view.
    ///     - edgeInsets: The amount to inset the presented view controller from
    ///                   the presenting view controller. This is a minimum;
    ///                   there may be additional insets depending on the safe
    ///                   area insets of the presenting view controller’s view.
    ///     - ignoredEdgesForMargins: Edges of the presenting view controller’s
    ///                               view for which its margins should be
    ///                               ignored for layout purposes.
    public convenience init(cornerRadius: CGFloat,
                            dimmingViewAlpha: CGFloat?,
                            edgeInsets: UIEdgeInsets,
                            ignoredEdgesForMargins: ViewEdge = []) {
        let options = SheetPresentationOptions(
            cornerRadius: cornerRadius,
            dimmingViewAlpha: dimmingViewAlpha,
            edgeInsets: edgeInsets,
            ignoredEdgesForMargins: ignoredEdgesForMargins)

        self.init(options: options)
    }

    /// Creates a `SheetPresentationManager` with specific presentation
    /// options and the default tap handler.
    ///
    /// - Parameters:
    ///     - cornerRadius: The corner radius to use when displaying the
    ///                     presented view controller.
    ///     - maskedCorners: The corners to mask using the `cornerRadius`.
    ///     - dimmingViewAlpha: The `alpha` value for the dimming view used
    ///                         behind the presented view controller. The color
    ///                         is black. Use `nil` to avoid using a dimmming
    ///                         view.
    ///     - edgeInsets: The amount to inset the presented view controller from
    ///                   the presenting view controller. This is a minimum;
    ///                   there may be additional insets depending on the safe
    ///                   area insets of the presenting view controller’s view.
    ///     - ignoredEdgesForMargins: Edges of the presenting view controller’s
    ///                               view for which its margins should be
    ///                               ignored for layout purposes.
    public convenience init(cornerRadius: CGFloat,
                            maskedCorners: CACornerMask = .all,
                            dimmingViewAlpha: CGFloat?,
                            edgeInsets: UIEdgeInsets,
                            ignoredEdgesForMargins: ViewEdge = []) {
        let options = SheetPresentationOptions(
            cornerRadius: cornerRadius,
            maskedCorners: maskedCorners,
            dimmingViewAlpha: dimmingViewAlpha,
            edgeInsets: edgeInsets,
            ignoredEdgesForMargins: ignoredEdgesForMargins)

        self.init(options: options)
    }

    /// Creates a `SheetPresentationManager` with specific presentation
    /// options and tap target/action.
    ///
    /// - Parameters:
    ///     - dimmingViewAlpha: The `alpha` value for the dimming view used
    ///                         behind the presented view controller. The color
    ///                         is black.
    ///     - edgeInsets: The amount to inset the presented view controller from
    ///                   the presenting view controller. This is a minimum;
    ///                   there may be additional insets depending on the safe
    ///                   area insets of the presenting view controller’s view.
    ///     - dimmingViewTapHandler: A block to be called when the dimming view
    ///                              is tapped. Its argument is the presented
    ///                              `UIViewController`.
    ///     - ignoredEdgesForMargins: Edges of the presenting view controller’s
    ///                               view for which its margins should be
    ///                               ignored for layout purposes.
    public convenience init(
        dimmingViewAlpha: CGFloat,
        edgeInsets: UIEdgeInsets,
        ignoredEdgesForMargins: ViewEdge = [],
        dimmingViewTapHandler: @escaping (UIViewController) -> Void
        ) {
        let options = SheetPresentationOptions(
            dimmingViewAlpha: dimmingViewAlpha,
            edgeInsets: edgeInsets,
            ignoredEdgesForMargins: ignoredEdgesForMargins)

        self.init(options: options,
                  dimmingViewTapHandler: .block(dimmingViewTapHandler))
    }

    /// Creates a `SheetPresentationManager` with specific presentation
    /// options and tap target/action.
    ///
    /// - Parameters:
    ///     - cornerRadius: The corner radius to use when displaying the
    ///                     presented view controller.
    ///     - dimmingViewAlpha: The `alpha` value for the dimming view used
    ///                         behind the presented view controller. The color
    ///                         is black.
    ///     - edgeInsets: The amount to inset the presented view controller from
    ///                   the presenting view controller. This is a minimum;
    ///                   there may be additional insets depending on the safe
    ///                   area insets of the presenting view controller’s view.
    ///     - dimmingViewTapHandler: A block to be called when the dimming view
    ///                              is tapped. Its argument is the presented
    ///                              `UIViewController`.
    ///     - ignoredEdgesForMargins: Edges of the presenting view controller’s
    ///                               view for which its margins should be
    ///                               ignored for layout purposes.
    public convenience init(
        cornerRadius: CGFloat,
        dimmingViewAlpha: CGFloat,
        edgeInsets: UIEdgeInsets,
        ignoredEdgesForMargins: ViewEdge = [],
        dimmingViewTapHandler: @escaping (UIViewController) -> Void
        ) {
        let options = SheetPresentationOptions(
            cornerRadius: cornerRadius,
            dimmingViewAlpha: dimmingViewAlpha,
            edgeInsets: edgeInsets,
            ignoredEdgesForMargins: ignoredEdgesForMargins)

        self.init(options: options,
                  dimmingViewTapHandler: .block(dimmingViewTapHandler))
    }

    /// Creates a `SheetPresentationManager` with specific presentation
    /// options and tap target/action.
    ///
    /// - Parameters:
    ///     - cornerRadius: The corner radius to use when displaying the
    ///                     presented view controller.
    ///     - maskedCorners: The corners to mask using the `cornerRadius`.
    ///     - dimmingViewAlpha: The `alpha` value for the dimming view used
    ///                         behind the presented view controller. The color
    ///                         is black.
    ///     - edgeInsets: The amount to inset the presented view controller from
    ///                   the presenting view controller. This is a minimum;
    ///                   there may be additional insets depending on the safe
    ///                   area insets of the presenting view controller’s view.
    ///     - dimmingViewTapHandler: A block to be called when the dimming view
    ///                              is tapped. Its argument is the presented
    ///                              `UIViewController`.
    ///     - ignoredEdgesForMargins: Edges of the presenting view controller’s
    ///                               view for which its margins should be
    ///                               ignored for layout purposes.
    public convenience init(
        cornerRadius: CGFloat,
        maskedCorners: CACornerMask,
        dimmingViewAlpha: CGFloat,
        edgeInsets: UIEdgeInsets,
        ignoredEdgesForMargins: ViewEdge = [],
        dimmingViewTapHandler: @escaping (UIViewController) -> Void
        ) {
        let options = SheetPresentationOptions(
            cornerRadius: cornerRadius,
            maskedCorners: maskedCorners,
            dimmingViewAlpha: dimmingViewAlpha,
            edgeInsets: edgeInsets,
            ignoredEdgesForMargins: ignoredEdgesForMargins)

        self.init(options: options,
                  dimmingViewTapHandler: .block(dimmingViewTapHandler))
    }

    /// Creates a `SheetPresentationManager` with specific presentation
    /// options.
    ///
    /// - Parameters:
    ///     - dimmingViewAlpha: The `alpha` value for the dimming view used
    ///                         behind the presented view controller. The color
    ///                         is black.
    ///     - edgeInsets: The amount to inset the presented view controller from
    ///                   the presenting view controller. This is a minimum;
    ///                   there may be additional insets depending on the safe
    ///                   area insets of the presenting view controller’s view.
    ///     - ignoredEdgesForMargins: Edges of the presenting view controller’s
    ///                               view for which its margins should be
    ///                               ignored for layout purposes.
    ///     - target: The target to call when the dimming view is
    ///                             tapped.
    ///     - action: The action selector to call on the target
    ///                             when the dimming view is tapped.
    public convenience init(dimmingViewAlpha: CGFloat,
                            edgeInsets: UIEdgeInsets,
                            ignoredEdgesForMargins: ViewEdge,
                            dimmingViewTapTarget target: NSObjectProtocol,
                            dimmingViewTapAction action: Selector) {
        let options = SheetPresentationOptions(
            dimmingViewAlpha: dimmingViewAlpha,
            edgeInsets: edgeInsets,
            ignoredEdgesForMargins: ignoredEdgesForMargins)

        self.init(options: options,
                  dimmingViewTapHandler: .targetAction(target, action))
    }

    /// Creates a `SheetPresentationManager` with specific presentation
    /// options.
    ///
    /// - Parameters:
    ///     - cornerRadius: The corner radius to use when displaying the
    ///                     presented view controller.
    ///     - dimmingViewAlpha: The `alpha` value for the dimming view used
    ///                         behind the presented view controller. The color
    ///                         is black.
    ///     - edgeInsets: The amount to inset the presented view controller from
    ///                   the presenting view controller. This is a minimum;
    ///                   there may be additional insets depending on the safe
    ///                   area insets of the presenting view controller’s view.
    ///     - ignoredEdgesForMargins: Edges of the presenting view controller’s
    ///                               view for which its margins should be
    ///                               ignored for layout purposes.
    ///     - target: The target to call when the dimming view is
    ///                             tapped.
    ///     - action: The action selector to call on the target
    ///                             when the dimming view is tapped.
    public convenience init(cornerRadius: CGFloat,
                            dimmingViewAlpha: CGFloat,
                            edgeInsets: UIEdgeInsets,
                            ignoredEdgesForMargins: ViewEdge,
                            dimmingViewTapTarget target: NSObjectProtocol,
                            dimmingViewTapAction action: Selector) {
        let options = SheetPresentationOptions(
            cornerRadius: cornerRadius,
            dimmingViewAlpha: dimmingViewAlpha,
            edgeInsets: edgeInsets,
            ignoredEdgesForMargins: ignoredEdgesForMargins)

        self.init(options: options,
                  dimmingViewTapHandler: .targetAction(target, action))
    }

    /// Creates a `SheetPresentationManager` with specific presentation
    /// options.
    ///
    /// - Parameters:
    ///     - cornerRadius: The corner radius to use when displaying the
    ///                     presented view controller.
    ///     - maskedCorners: The corners to mask using the `cornerRadius`.
    ///     - dimmingViewAlpha: The `alpha` value for the dimming view used
    ///                         behind the presented view controller. The color
    ///                         is black.
    ///     - edgeInsets: The amount to inset the presented view controller from
    ///                   the presenting view controller. This is a minimum;
    ///                   there may be additional insets depending on the safe
    ///                   area insets of the presenting view controller’s view.
    ///     - ignoredEdgesForMargins: Edges of the presenting view controller’s
    ///                               view for which its margins should be
    ///                               ignored for layout purposes.
    ///     - target: The target to call when the dimming view is
    ///                             tapped.
    ///     - action: The action selector to call on the target
    ///                             when the dimming view is tapped.
    public convenience init(cornerRadius: CGFloat,
                            maskedCorners: CACornerMask,
                            dimmingViewAlpha: CGFloat,
                            edgeInsets: UIEdgeInsets,
                            ignoredEdgesForMargins: ViewEdge,
                            dimmingViewTapTarget target: NSObjectProtocol,
                            dimmingViewTapAction action: Selector) {
        let options = SheetPresentationOptions(
            cornerRadius: cornerRadius,
            maskedCorners: maskedCorners,
            dimmingViewAlpha: dimmingViewAlpha,
            edgeInsets: edgeInsets,
            ignoredEdgesForMargins: ignoredEdgesForMargins)

        self.init(options: options,
                  dimmingViewTapHandler: .targetAction(target, action))
    }

}

extension SheetPresentationManager:
UIViewControllerTransitioningDelegate {

    /// Asks your delegate for the custom presentation controller to use for
    /// managing the view hierarchy when presenting a view controller.
    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
        ) -> UIPresentationController? {
        let controller = SheetPresentationController(
            forPresented: presented,
            presenting: presenting,
            presentationOptions: presentationOptions,
            dimmingViewTapHandler: dimmingViewTapHandler)

        controller.delegate = self

        return controller
    }

}

extension SheetPresentationManager:
UIAdaptivePresentationControllerDelegate {

    /// Asks the delegate for the presentation style to use when the specified
    /// set of traits are active.
    public func adaptivePresentationStyle(
        for controller: UIPresentationController,
        traitCollection: UITraitCollection
        ) -> UIModalPresentationStyle {
        return .overCurrentContext
    }

    /// Asks the delegate for the new presentation style to use.
    public func adaptivePresentationStyle(
        for controller: UIPresentationController
        ) -> UIModalPresentationStyle {
        return .overCurrentContext
    }

}
