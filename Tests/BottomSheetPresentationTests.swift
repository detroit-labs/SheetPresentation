//
//  BottomSheetPresentationTests.swift
//  BottomSheetPresentationTests
//
//  Created by Jeff Kelley on 7/19/18.
//  Copyright © 2018 Detroit Labs, LLC. All rights reserved.
//

import XCTest
@testable import BottomSheetPresentation

class BottomSheetPresentationOptionsTests: XCTestCase {

    func testThatTheDefaultInitUsesDefaultPresentationOptions() {
        let subject = BottomSheetPresentationManager()
        XCTAssertEqual(subject.presentationOptions, .defaultOptions)
    }

    func testThatInitWithPresentationOptionsUsesThoseOptions() {
        let presentationOptions = BottomSheetPresentationOptions(
            cornerRadius: 42,
            dimmingViewAlpha: 31,
            edgeInsets: .zero,
            direction: .bottom)

        let subject = BottomSheetPresentationManager(options: presentationOptions)
        XCTAssertEqual(subject.presentationOptions, presentationOptions)
    }

    func testThatInitWithPresentationValuesUsesThoseValues() {
        let expectedPresentationOptions = BottomSheetPresentationOptions(
            cornerRadius: 42,
            dimmingViewAlpha: 31,
            edgeInsets: .zero,
            direction: .bottom)

        let subject = BottomSheetPresentationManager(cornerRadius: 42,
                                                     dimmingViewAlpha: 31,
                                                     edgeInsets: .zero,
                                                     direction: .bottom)

        XCTAssertEqual(subject.presentationOptions, expectedPresentationOptions)
    }

    func testThatCreatingAPresentationControllerUsesPresentationOptions() {

        let presentingViewController = UIViewController()
        let presentedViewController = UIViewController()
        let source = UIViewController()

        let presentationOptions = BottomSheetPresentationOptions(
            cornerRadius: 42,
            dimmingViewAlpha: 31,
            edgeInsets: .zero,
            direction: .bottom)

        let subject = BottomSheetPresentationManager(options: presentationOptions)

        let presentationController = subject.presentationController(
            forPresented: presentedViewController,
            presenting: presentingViewController,
            source: source) as! BottomSheetPresentationController

        XCTAssertEqual(presentationController.cornerRadius,
                       presentationOptions.cornerRadius)

        XCTAssertEqual(presentationController.dimmingViewAlpha,
                       presentationOptions.dimmingViewAlpha)

        XCTAssertEqual(presentationController.edgeInsets,
                       presentationOptions.edgeInsets)

        XCTAssertEqual(presentationController.direction,
                       presentationOptions.direction)

    }

}

class BottomSheetPresentationManagerTests: XCTestCase {

    var subject: BottomSheetPresentationManager!
    var customizedSheetManager: BottomSheetPresentationManager!

    override func setUp() {
        super.setUp()
        subject = BottomSheetPresentationManager()
        customizedSheetManager = BottomSheetPresentationManager(options: BottomSheetPresentationOptions(cornerRadius: 10, dimmingViewAlpha: 10, edgeInsets: UIEdgeInsets(constant: 12), direction: .left))
    }

    func createPresentationControllerWithMockVCs() -> BottomSheetPresentationController {
        return subject.presentationController(
            forPresented: UIViewController(),
            presenting: UIViewController(),
            source: UIViewController()) as! BottomSheetPresentationController
    }

}

class BottomSheetPresentationManagerUIViewControllerTransitioningDelegateTests: BottomSheetPresentationManagerTests {

    func testThatCreatedPresentationControllersHaveTheirDelegateSet() {

        XCTAssertTrue(
            createPresentationControllerWithMockVCs().delegate === subject
        )

    }

    func testAnimationControllerForPresentedReturnsNilForBottomDirection() {
        XCTAssertNil(subject.animationController(forPresented: UIViewController(), presenting: UIViewController(), source: UIViewController()))
    }

    func testAnimationControllerForPresentedReturnsSheetPresentationAnimator() {
        XCTAssertTrue(customizedSheetManager.animationController(forPresented: UIViewController(), presenting: UIViewController(), source: UIViewController()) is SheetPresentationAnimator)
    }

    func testAnimationControllerForDismissedReturnsNilForBottomDirection() {
        XCTAssertNil(subject.animationController(forDismissed: UIViewController()))
    }

    func testAnimationControllerForDismissedReturnsSheetPresentationAnimator() {
        XCTAssertTrue(customizedSheetManager.animationController(forDismissed: UIViewController()) is SheetPresentationAnimator)
    }

}

class BottomSheetPresentationManagerUIAdaptivePresentationControllerDelegateTests: BottomSheetPresentationManagerTests {

    func testThatAdaptivePresentationStyleIsOverCurrentContext() {

        let presentationController = createPresentationControllerWithMockVCs()

        XCTAssertEqual(
            subject.adaptivePresentationStyle(for: presentationController),
            .overCurrentContext)

        let traitCollection = UITraitCollection()

        XCTAssertEqual(
            subject.adaptivePresentationStyle(for: presentationController,
                                              traitCollection: traitCollection),
            .overCurrentContext)
    }

}

class BottomSheetPresentationControllerTests: XCTestCase {

    var subject: BottomSheetPresentationController!

    override func setUp() {
        super.setUp()

        subject = BottomSheetPresentationController(
            forPresented: UIViewController(),
            presenting: UIViewController())
    }

    func testThatSettingCornerRadiusUpdatesLayoutContainer() {
        subject.cornerRadius = 42
        XCTAssertEqual(subject.layoutContainer?.layer.cornerRadius,
                       42)
    }

    func testThatSettingDimmingViewAlphaUpdatesDimmingView() {
        subject.dimmingViewAlpha = 0.42

        var alpha: CGFloat = 0
        subject.dimmingView?.backgroundColor?.getWhite(nil, alpha: &alpha)

        XCTAssertEqual(alpha, 0.42)
    }

    func testThatUpdatingEdgeInsetsUpdatesLayout() {
        let edgeInsets = UIEdgeInsets(constant: 42)
        subject.edgeInsets = edgeInsets

        // TODO: Test that container view gets setNeedsLayout() called
    }

    func testThatTheLayoutContainerIsThePresentedView() {
        XCTAssertEqual(subject.presentedView, subject.layoutContainer)
    }

}

class SheetPresentationAnimatorTests: XCTestCase {

    var sut: SheetPresentationAnimator!

    override func setUp() {
        super.setUp()

        sut = SheetPresentationAnimator(direction: .bottom, isPresentation: true)
    }

    func testTransitionDurationReturnsTimeInterval() {
        XCTAssertTrue(sut.transitionDuration(using: nil) >= 0)
    }

}
