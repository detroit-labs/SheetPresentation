//
//  SheetAnimationController.swift
//  SheetPresentation
//
//  Created by Jeff Kelley on 7/9/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import UIKit

final class SheetAnimationController: NSObject {

    private let duration: TimeInterval = 1.0 / 3.0

    private let isPresenting: Bool
    private let edge: SheetPresentationOptions.PresentationEdge

    private var currentAnimator: UIViewPropertyAnimator?

    init(isPresenting: Bool, edge: SheetPresentationOptions.PresentationEdge) {
        self.isPresenting = isPresenting
        self.edge = edge

        super.init()
    }

}

extension SheetAnimationController: UIViewControllerAnimatedTransitioning {

    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        interruptibleAnimator(using: transitionContext).startAnimation()
    }

    func animationEnded(_ transitionCompleted: Bool) {
        currentAnimator = nil
    }

    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        duration
    }

    func interruptibleAnimator(
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

        let presentedFrame = transitionContext.finalFrame(for: controller)

        if isPresenting {
            transitionContext.containerView.addSubview(view)
            view.frame = presentedFrame
        }

        let translationTransform: CGAffineTransform
        switch edge {
        case .top:
            translationTransform = .init(
                translationX: 0, y: -presentedFrame.maxY
            )
        case .leading:
            translationTransform = .init(
                translationX: -presentedFrame.maxX, y: 0
            )
        case .trailing:
            translationTransform = .init(
                translationX: presentedFrame.maxX, y: 0
            )
        case .bottom:
            translationTransform = .init(
                translationX: 0, y: presentedFrame.maxY
            )
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
            transitionContext.completeTransition(
                !transitionContext.transitionWasCancelled
            )
        }

        currentAnimator = animator

        return animator
    }
}
