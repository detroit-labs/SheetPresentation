//
//  SheetAnimationController.swift
//  SheetPresentation
//
//  Created by Jeff Kelley on 7/9/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import UIKit

final class SheetAnimationController: NSObject {

    let duration: TimeInterval = 1.0 / 3.0
    let edge: ViewEdgeConvertible
    let isPresenting: Bool

    private var currentAnimator: UIViewPropertyAnimator?

    init(isPresenting: Bool, edge: ViewEdgeConvertible) {
        self.isPresenting = isPresenting
        self.edge = edge

        super.init()
    }

    private func offscreenTransform(
        forPresentedFrame presentedFrame: CGRect,
        containerFrame: CGRect,
        using traitCollection: UITraitCollection
    ) -> CGAffineTransform {
        switch edge.fixedViewEdge(using: traitCollection) {
        case .top:
            return CGAffineTransform(
                translationX: 0,
                y: containerFrame.minY - presentedFrame.maxY
            )

        case .left:
            return CGAffineTransform(
                translationX: containerFrame.minX - presentedFrame.maxX,
                y: 0
            )

        case .right:
            return CGAffineTransform(
                translationX: containerFrame.maxX - presentedFrame.minX,
                y: 0
            )

        case .bottom:
            return CGAffineTransform(
                translationX: 0,
                y: containerFrame.maxY - presentedFrame.minY
            )
        }
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

        let animator = UIViewPropertyAnimator(duration: duration,
                                              curve: .easeInOut)

        let controllerKey: UITransitionContextViewControllerKey =
            (isPresenting) ? .to : .from

        let viewKey: UITransitionContextViewKey = (isPresenting) ? .to : .from

        if let view = transitionContext.view(forKey: viewKey),
            let controller = transitionContext
                .viewController(forKey: controllerKey) {
            let presentedFrame = transitionContext.finalFrame(for: controller)

            if isPresenting {
                transitionContext.containerView.addSubview(view)
                view.frame = presentedFrame
            }

            let containerFrame = transitionContext.containerView.frame

            let translationTransform = offscreenTransform(
                forPresentedFrame: presentedFrame,
                containerFrame: containerFrame,
                using: controller.traitCollection
            )

            let startTransform = isPresenting ? translationTransform : .identity
            let endTransform = isPresenting ? .identity : translationTransform

            view.transform = startTransform

            animator.addAnimations {
                view.transform = endTransform
            }
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
