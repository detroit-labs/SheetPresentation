//
//  MockContextTransitioning.swift
//  SheetPresentationTests
//
//  Created by Jeff Kelley on 8/21/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import UIKit

class MockContext: NSObject {

    lazy var containerView = UIView(
        frame: CGRect(x: 0, y: 0, width: 320, height: 480)
    )

    var isAnimated = true
    var isInteractive = false
    var transitionWasCancelled = false
    var presentationStyle = UIModalPresentationStyle.custom
    var targetTransform = CGAffineTransform.identity

    typealias ViewControllerKey = UITransitionContextViewControllerKey

    var viewControllers: [ViewControllerKey: UIViewController] = [:]
    var views: [UITransitionContextViewKey: UIView] = [:]

    var finalFrames: [UIViewController: CGRect] = [:]

}

extension MockContext: UIViewControllerContextTransitioning {

    func updateInteractiveTransition(_ percentComplete: CGFloat) {

    }

    func finishInteractiveTransition() {

    }

    func cancelInteractiveTransition() {

    }

    func pauseInteractiveTransition() {

    }

    func completeTransition(_ didComplete: Bool) {

    }

    func viewController(
        forKey key: UITransitionContextViewControllerKey
    ) -> UIViewController? {
        viewControllers[key]
    }

    func view(forKey key: UITransitionContextViewKey) -> UIView? {
        views[key]
    }

    func initialFrame(for viewController: UIViewController) -> CGRect {
        .zero
    }

    func finalFrame(for viewController: UIViewController) -> CGRect {
        finalFrames[viewController] ?? .zero
    }

}
