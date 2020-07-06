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
        $0.dismiss(animated: true, completion: nil)}
    )

}

/// An object that creates instances of `SheetPresentationController` when
/// set as a view controller’s `transitioningDelegate`.
public final class SheetPresentationManager: NSObject {

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

}

public final class SheetAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    private let duration = 0.3

    private let isPresenting: Bool
    private let edge: SheetPresentationOptions.PresentationEdge

    private var currentAnimator: UIViewPropertyAnimator?

    public init(isPresenting: Bool,
                edge: SheetPresentationOptions.PresentationEdge) {
        self.isPresenting = isPresenting
        self.edge = edge

        super.init()
    }

    public func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        duration
    }

    public func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        interruptibleAnimator(using: transitionContext).startAnimation()
    }

    public func interruptibleAnimator(
        using transitionContext: UIViewControllerContextTransitioning
    ) -> UIViewImplicitlyAnimating {
        if let animator = currentAnimator { return animator }

        let controllerKey: UITransitionContextViewControllerKey =
            (isPresenting) ? .to : .from

        let viewKey: UITransitionContextViewKey = (isPresenting) ? .to : .from

        guard let view = transitionContext.view(forKey: viewKey),
              let controller = transitionContext
                .viewController(forKey: controllerKey) else {
            fatalError("Destination view not found during transition.")
        }

//        guard
//        let controller = transitionContext.viewController(forKey: key) else {
//            fatalError("Controller not found during transition.")
//        }

        if isPresenting {
            transitionContext.containerView.addSubview(view)
        }

        let presentedFrame = transitionContext.finalFrame(for: controller)
//        controller.view.translatesAutoresizingMaskIntoConstraints = false
//        view.translatesAutoresizingMaskIntoConstraints = false
//        var dismissedFrame = presentedFrame

        let translationTransform: CGAffineTransform
        switch edge {
        case .leading:
            translationTransform = .init(
                translationX: -presentedFrame.width, y: 0
            )
//            dismissedFrame.origin.x = -presentedFrame.width
        case .trailing:
            translationTransform = .init(
                translationX: presentedFrame.width, y: 0
            )
//            dismissedFrame.origin.x = transitionContext.containerView
//                                                        .frame
//                                                        .size
//                                                        .width
        case .bottom:
            translationTransform = .init(
                translationX: 0, y: presentedFrame.height
            )
//            dismissedFrame.origin.y = transitionContext.containerView
//                                                        .frame
//                                                        .size
//                                                        .height
        }

        let initialTransform = isPresenting ? translationTransform : .identity
        let finalTransform = isPresenting ? .identity : translationTransform

        view.transform = initialTransform

        let animator = UIViewPropertyAnimator(duration: duration,
                                              curve: .easeInOut)

        animator.addAnimations {
            view.transform = finalTransform
        }

        animator.addCompletion { _ in
            print("Animation complete.")
            self.currentAnimator = nil
            transitionContext.completeTransition(
                !transitionContext.transitionWasCancelled
            )
        }

        currentAnimator = animator

        return animator
    }
}

extension SheetPresentationManager:
UIViewControllerTransitioningDelegate {

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

    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        let edge = presentationOptions.presentationEdge
        switch edge {
        case .leading, .trailing:
            return SheetAnimationController(isPresenting: true, edge: edge)
        case .bottom:
            return nil
        }
    }

    public func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        let edge = presentationOptions.presentationEdge
        switch edge {
        case .leading, .trailing:
            return SheetAnimationController(isPresenting: false, edge: edge)
        case .bottom:
            return nil
        }
    }

}

extension SheetPresentationManager:
UIAdaptivePresentationControllerDelegate {

    public func adaptivePresentationStyle(
        for controller: UIPresentationController,
        traitCollection: UITraitCollection
    ) -> UIModalPresentationStyle {
        .overCurrentContext
    }

    public func adaptivePresentationStyle(
        for controller: UIPresentationController
    ) -> UIModalPresentationStyle {
        .overCurrentContext
    }

}
