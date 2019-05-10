//
//  BottomSheetPresentationManager.swift
//  BottomSheetPresentation
//
//  Created by Jeff Kelley on 5/10/19.
//  Copyright © 2019 Detroit Labs. All rights reserved.
//

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
    ///
    /// - SeeAlso:
    ///   - `DimmingViewTapHandler.default`
    @available(*, deprecated, renamed: "default")
    public static let defaultHandler: DimmingViewTapHandler = .default

    /// The default handler, which will dismiss the presented view controller
    /// upon tapping.
    public static let `default` = DimmingViewTapHandler.block({
        $0.dismiss(animated: true, completion: nil)}
    )

}

/// An object that creates instances of `BottomSheetPresentationController` when
/// set as a view controller’s `transitioningDelegate`.
@objcMembers public final class BottomSheetPresentationManager: NSObject {

    internal let presentationOptions: BottomSheetPresentationOptions
    internal let dimmingViewTapHandler: DimmingViewTapHandler

    /// Creates a `BottomSheetPresentationManager` with specific presentation
    /// options and tap handler.
    ///
    /// - Parameters:
    ///     - options: The options to use for presenting view controllers.
    ///     - dimmingViewTapHandler: A handler to be called when tapping the
    ///                              dimming view.
    public init(
        options: BottomSheetPresentationOptions = .default,
        dimmingViewTapHandler: DimmingViewTapHandler = .default
        ) {
        presentationOptions = options
        self.dimmingViewTapHandler = dimmingViewTapHandler
    }

    /// Creates a `BottomSheetPresentationManager` with specific presentation
    /// options and the default tap handler.
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
    public convenience init(cornerRadius: CGFloat,
                            dimmingViewAlpha: CGFloat,
                            edgeInsets: UIEdgeInsets) {
        let options = BottomSheetPresentationOptions(
            cornerRadius: cornerRadius,
            dimmingViewAlpha: dimmingViewAlpha,
            edgeInsets: edgeInsets)

        self.init(options: options)
    }

    /// Creates a `BottomSheetPresentationManager` with specific presentation
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
    public convenience init(
        cornerRadius: CGFloat,
        dimmingViewAlpha: CGFloat,
        edgeInsets: UIEdgeInsets,
        dimmingViewTapHandler: @escaping (UIViewController) -> Void
        ) {
        let options = BottomSheetPresentationOptions(
            cornerRadius: cornerRadius,
            dimmingViewAlpha: dimmingViewAlpha,
            edgeInsets: edgeInsets)

        self.init(options: options,
                  dimmingViewTapHandler: .block(dimmingViewTapHandler))
    }

    /// Creates a `BottomSheetPresentationManager` with specific presentation
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
    ///     - target: The target to call when the dimming view is
    ///                             tapped.
    ///     - action: The action selector to call on the target
    ///                             when the dimming view is tapped.
    public convenience init(cornerRadius: CGFloat,
                            dimmingViewAlpha: CGFloat,
                            edgeInsets: UIEdgeInsets,
                            dimmingViewTapTarget target: NSObjectProtocol,
                            dimmingViewTapAction action: Selector) {
        let options = BottomSheetPresentationOptions(
            cornerRadius: cornerRadius,
            dimmingViewAlpha: dimmingViewAlpha,
            edgeInsets: edgeInsets)

        self.init(options: options,
                  dimmingViewTapHandler: .targetAction(target, action))
    }

}

extension BottomSheetPresentationManager:
UIViewControllerTransitioningDelegate {

    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
        ) -> UIPresentationController? {
        let controller = BottomSheetPresentationController(
            forPresented: presented,
            presenting: presenting,
            presentationOptions: presentationOptions,
            dimmingViewTapHandler: dimmingViewTapHandler)

        controller.delegate = self

        return controller
    }

}

extension BottomSheetPresentationManager:
UIAdaptivePresentationControllerDelegate {

    public func adaptivePresentationStyle(
        for controller: UIPresentationController,
        traitCollection: UITraitCollection
        ) -> UIModalPresentationStyle {
        return .overCurrentContext
    }

    public func adaptivePresentationStyle(
        for controller: UIPresentationController
        ) -> UIModalPresentationStyle {
        return .overCurrentContext
    }

}
