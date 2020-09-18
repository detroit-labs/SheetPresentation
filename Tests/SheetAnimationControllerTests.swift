//
//  SheetAnimationControllerTests.swift
//  SheetPresentationTests
//
//  Created by Jeff Kelley on 8/21/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

@testable import SheetPresentation

import UIKit
import XCTest

final class SheetAnimationControllerTests: XCTestCase {

    var contextTransitioning: UIViewControllerContextTransitioning!

    override func setUp() {
        super.setUp()

        let mockContextTransitioning = MockContext()

        let toViewController = UIViewController()
        mockContextTransitioning.viewControllers[.to] = toViewController
        mockContextTransitioning.views[.to] = toViewController.view

        mockContextTransitioning.finalFrames[toViewController] = CGRect(
            x: 0, y: 0, width: 100, height: 100
        )

        let fromViewController = UIViewController()
        mockContextTransitioning.viewControllers[.from] = fromViewController
        mockContextTransitioning.views[.from] = fromViewController.view

        contextTransitioning = mockContextTransitioning
    }

    func testCreatingAnAnimatorForPresentingAddsViewToContainer() throws {
        let subject = SheetAnimationController(isPresenting: true,
                                               edge: FixedViewEdge.bottom)

        _ = subject.interruptibleAnimator(using: contextTransitioning)

        let toView = try XCTUnwrap(contextTransitioning.view(forKey: .to))

        XCTAssertTrue(
            contextTransitioning.containerView.subviews.contains(toView)
        )
    }

    func testCreatingAnAnimatorForPresentingSetsFrameOfPresentedView() throws {
        let subject = SheetAnimationController(isPresenting: true,
                                               edge: FixedViewEdge.bottom)

        _ = subject.interruptibleAnimator(using: contextTransitioning)

        let toView = try XCTUnwrap(contextTransitioning.view(forKey: .to))

        let toViewController = try XCTUnwrap(
            contextTransitioning.viewController(forKey: .to)
        )

        // Force the transfrom to `.identity` so that the value of `.frame` is
        // valid.
        toView.transform = .identity

        XCTAssertEqual(toView.frame,
                       contextTransitioning.finalFrame(for: toViewController))
    }

    func testPresentingFromBottomSetsTransformToBottom() throws {
        let subject = SheetAnimationController(isPresenting: true,
                                               edge: FixedViewEdge.bottom)

        _ = subject.interruptibleAnimator(using: contextTransitioning)

        let toView = try XCTUnwrap(contextTransitioning.view(forKey: .to))

        let expectedTransform = CGAffineTransform.init(
            translationX: 0,
            y: contextTransitioning.containerView.frame.height
        )

        XCTAssertEqual(toView.transform, expectedTransform)
    }

    func testPresentingFromTopSetsTransformToTop() throws {
        let subject = SheetAnimationController(isPresenting: true,
                                               edge: FixedViewEdge.top)

        _ = subject.interruptibleAnimator(using: contextTransitioning)

        let toView = try XCTUnwrap(contextTransitioning.view(forKey: .to))

        let expectedTransform = CGAffineTransform.init(
            translationX: 0,
            y: -toView.frame.height
        )

        XCTAssertEqual(toView.transform, expectedTransform)
    }

    func testPresentingFromLeftSetsTransformToLeft() throws {
        let subject = SheetAnimationController(isPresenting: true,
                                               edge: FixedViewEdge.left)

        _ = subject.interruptibleAnimator(using: contextTransitioning)

        let toView = try XCTUnwrap(contextTransitioning.view(forKey: .to))

        let expectedTransform = CGAffineTransform.init(
            translationX: -toView.frame.width,
            y: 0
        )

        XCTAssertEqual(toView.transform, expectedTransform)
    }

    func testPresentingFromRightSetsTransformToRight() throws {
        let subject = SheetAnimationController(isPresenting: true,
                                               edge: FixedViewEdge.right)

        _ = subject.interruptibleAnimator(using: contextTransitioning)

        let toView = try XCTUnwrap(contextTransitioning.view(forKey: .to))

        let expectedTransform = CGAffineTransform.init(
            translationX: contextTransitioning.containerView.frame.width,
            y: 0
        )

        XCTAssertEqual(toView.transform, expectedTransform)
    }

    func testDismissingSetsTransformToIdentity() throws {
        let subject = SheetAnimationController(isPresenting: false,
                                               edge: FixedViewEdge.bottom)

        _ = subject.interruptibleAnimator(using: contextTransitioning)

        let fromView = try XCTUnwrap(contextTransitioning.view(forKey: .from))

        XCTAssertEqual(fromView.transform, .identity)
    }

    func testAnimationStarting() {
        let subject = SheetAnimationController(isPresenting: true,
                                               edge: FixedViewEdge.bottom)

        let animator = subject.interruptibleAnimator(
            using: contextTransitioning
        )

        XCTAssertEqual(animator.state, .inactive)

        subject.animateTransition(using: contextTransitioning)

        XCTAssertEqual(animator.state, .active)

    }

    func testTransitionDuration() {
        let subject = SheetAnimationController(isPresenting: true,
                                               edge: FixedViewEdge.bottom)

        XCTAssertEqual(subject.transitionDuration(using: nil), 1 / 3)
    }

    func testAnimatorIsRetainedUponCreation() {
        let subject = SheetAnimationController(isPresenting: true,
                                               edge: FixedViewEdge.bottom)

        weak var animator = subject.interruptibleAnimator(
            using: contextTransitioning
        )

        XCTAssertNotNil(animator)
    }

    func testAnimatorIsDestroyedUponCompletion() {
        let subject = SheetAnimationController(isPresenting: true,
                                               edge: FixedViewEdge.bottom)

        weak var animator = subject.interruptibleAnimator(
            using: contextTransitioning
        )

        subject.animationEnded(true)

        XCTAssertNil(animator)
    }

}
