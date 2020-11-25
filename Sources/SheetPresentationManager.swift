//
//  SheetPresentationManager.swift
//  SheetPresentation
//
//  Created by Jeff Kelley on 5/10/19.
//  Copyright © 2020 Detroit Labs. All rights reserved.
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
    public static let `default` = DimmingViewTapHandler.block({
        $0.dismiss(animated: true, completion: nil)
    })

}

/// An object that creates instances of `SheetPresentationController` when
/// set as a view controller’s `transitioningDelegate`.
public final class SheetPresentationManager: NSObject {

    let presentationOptions: SheetPresentationOptions
    let dimmingViewTapHandler: DimmingViewTapHandler

    /// Creates a `SheetPresentationManager` with specific presentation
    /// options and tap handler.
    ///
    /// - Parameters:
    ///     - options: The options to use for presenting view controllers.
    ///     - dimmingViewTapHandler: A handler to be called when tapping the
    ///                              dimming view. The `dimmingViewAlpha` of the
    ///                              given `options` must not be `nil`, or the
    ///                              dimming view will not be created.
    public init(
        options: SheetPresentationOptions = .default,
        dimmingViewTapHandler: DimmingViewTapHandler = .default
    ) {
        presentationOptions = options
        self.dimmingViewTapHandler = dimmingViewTapHandler
    }

}

extension SheetPresentationManager: UIViewControllerTransitioningDelegate {

    /// Defines the animator object to use when presenting the view controller.
    ///
    /// - Parameters:
    ///   - presented: The view controller that is about to be presented
    ///                onscreen.
    ///   - presenting: The view controller that is presenting the view
    ///                 controller in the `presented` parameter. The object in
    ///                 this parameter could be the root view controller of the
    ///                 window, a parent view controller that is marked as
    ///                 defining the current context, or the last view
    ///                 controller that was presented. This view controller may
    ///                 or may not be the same as the one in the `source`
    ///                 parameter.
    ///   - source: The view controller whose `present(_:animated:completion:)`
    ///             method was called.
    /// - Returns: The animator object to use when presenting the view
    ///            controller or `nil` to use the system animator.
    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        switch presentationOptions.animationBehavior {
        case .system:
            return nil
        case .present(edgeForAppearance: let edge, edgeForDismissal: _):
            let edge = edge.fixedViewEdge(using: presented.traitCollection)
            return SheetAnimationController(isPresenting: true, edge: edge)
        case .custom(let animator, _):
            return animator
        }
    }

    /// Defines the animator object to use when dismissing the view controller.
    ///
    /// - Parameter dismissed: The view controller that is about to be
    ///                        dismissed.
    /// - Returns: The animator object to use when dismissing the view
    ///            controller or `nil` to use the system animator.
    public func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        switch presentationOptions.animationBehavior {
        case .system:
            return nil
        case .present(edgeForAppearance: _, edgeForDismissal: let edge):
            let edge = edge.fixedViewEdge(using: dismissed.traitCollection)
            return SheetAnimationController(isPresenting: false, edge: edge)
        case .custom(_, let animator):
            return animator
        }
    }

    /// Defines the custom presentation controller to use for managing the view
    /// hierarchy when presenting a view controller.
    ///
    /// - Parameters:
    ///   - presented: The view controller being presented.
    ///   - presenting: The view controller that is presenting the view
    ///                 controller in the `presented` parameter. The object in
    ///                 this parameter could be the root view controller of the
    ///                 window, a parent view controller that is marked as
    ///                 defining the current context, or the last view
    ///                 controller that was presented. This view controller may
    ///                 or may not be the same as the one in the `source`
    ///                 parameter. This parameter may also be `nil` to indicate
    ///                 that the presenting view controller will be determined
    ///                 later.
    ///   - source: The view controller whose `present(_:animated:completion:)`
    ///             method was called to initiate the presentation process.
    /// - Returns: The custom presentation controller for managing the modal
    ///            presentation.
    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        let controller = SheetPresentationController(
            forPresented: presented,
            presenting: presenting,
            presentationOptions: presentationOptions,
            dimmingViewTapHandler: dimmingViewTapHandler
        )

        controller.delegate = self

        return controller
    }

}

extension SheetPresentationManager: UIAdaptivePresentationControllerDelegate {

    /// Defines the modal presentation style for the controller given a set of
    /// traits.
    ///
    /// - Parameters:
    ///   - controller: The presentation controller that is managing the size
    ///                 change.
    ///   - traitCollection: The traits representing the target environment.
    /// - Returns: The new presentation style, which must be
    ///            `UIModalPresentationStyle.fullScreen`,
    ///            `UIModalPresentationStyle.overFullScreen`,
    ///            or `UIModalPresentationStyle.none`.
    public func adaptivePresentationStyle(
        for controller: UIPresentationController,
        traitCollection: UITraitCollection
    ) -> UIModalPresentationStyle {
        .overCurrentContext
    }

    /// Defines the modal presentation style for the controller.
    /// - Parameter controller: The presentation controller that is managing the
    ///                         size change.
    /// - Returns: The new presentation style, which must be
    ///            `UIModalPresentationStyle.fullScreen`,
    ///            `UIModalPresentationStyle.overFullScreen`,
    ///            or `UIModalPresentationStyle.none`.
    public func adaptivePresentationStyle(
        for controller: UIPresentationController
    ) -> UIModalPresentationStyle {
        .overCurrentContext
    }

}
