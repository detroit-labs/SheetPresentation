//
//  MockTransitionCoordinator.swift
//  SheetPresentationTests
//
//  Created by Jeff Kelley on 8/6/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import UIKit

// swiftlint:disable:next line_length
class MockTransitionCoordinator: NSObject, UIViewControllerTransitionCoordinatorContext {

    // MARK: - Mock Settings and Storage
    var animateAlongsideTransitionAnimation: Animation?
    var animateAlongsideTransitionCompletion: Completion?
    var animateAlongsideTransitionInAnimation: Animation?
    var animateAlongsideTransitionInCompletion: Completion?
    var animateAlongsideTransitionInView: UIView?

    // Set to true to execute the received animation and completion parameters
    // on the main queue automatically.
    var executeAnimationsAutomatically = false

    // Set to true to force animate(alongsideTransition:completion:) to return
    // false.
    var forceLegacyPath = false

    // MARK: - Getting the Views and View Controllers
    func viewController(
        forKey key: UITransitionContextViewControllerKey
    ) -> UIViewController? {
        nil
    }

    func view(forKey key: UITransitionContextViewKey) -> UIView? {
        nil
    }

    var containerView = UIView()

    // MARK: - Getting the Behavior Attributes
    var presentationStyle: UIModalPresentationStyle = .custom
    var transitionDuration: TimeInterval = 1.0 / 3.0
    var completionCurve = UIView.AnimationCurve.easeInOut
    var completionVelocity: CGFloat = 1
    var percentComplete: CGFloat = 0

    // MARK: - Getting the Transition State
    var initiallyInteractive = false
    var isAnimated = false
    var isInteractive = false
    var isCancelled = false
    var isInterruptible = false

    // MARK: - Getting the Rotation Factor
    var targetTransform = CGAffineTransform.identity

}

extension MockTransitionCoordinator: UIViewControllerTransitionCoordinator {

    typealias CoordinatorContext = UIViewControllerTransitionCoordinatorContext
    typealias Animation = (CoordinatorContext) -> Void
    typealias Completion = (CoordinatorContext) -> Void
    typealias Notification = (CoordinatorContext) -> Void

    // MARK: - Responding to View Controller Transition Progress
    func animate(
        alongsideTransition animation: Animation?,
        completion: Completion? = nil
    ) -> Bool {
        animateAlongsideTransitionAnimation = animation
        animateAlongsideTransitionCompletion = completion

        if forceLegacyPath { return false }

        if executeAnimationsAutomatically {
            if let animation = animation {
                DispatchQueue.main.async { animation(self) }
            }

            if let completion = completion {
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + transitionDuration,
                    execute: { completion(self) }
                )
            }

            return true
        }

        return true
    }

    func animateAlongsideTransition(
        in view: UIView?,
        animation: Animation?,
        completion: Completion? = nil
    ) -> Bool {
        animateAlongsideTransitionInAnimation = animation
        animateAlongsideTransitionInCompletion = completion
        animateAlongsideTransitionInView = view

        if executeAnimationsAutomatically {
            if let animation = animation {
                DispatchQueue.main.async { animation(self) }
            }

            if let completion = completion {
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + transitionDuration,
                    execute: { completion(self) }
                )
            }

            return true
        }

        return false
    }

    func notifyWhenInteractionChanges(_ handler: @escaping Notification) {

    }

    func notifyWhenInteractionEnds(_ handler: @escaping Notification) {

    }

}
