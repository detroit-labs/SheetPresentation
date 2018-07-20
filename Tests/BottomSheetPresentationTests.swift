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
            edgeInsets: .zero)

        let subject = BottomSheetPresentationManager(options: presentationOptions)
        XCTAssertEqual(subject.presentationOptions, presentationOptions)
    }

    func testThatInitWithPresentationValuesUsesThoseValues() {
        let expectedPresentationOptions = BottomSheetPresentationOptions(
            cornerRadius: 42,
            dimmingViewAlpha: 31,
            edgeInsets: .zero)

        let subject = BottomSheetPresentationManager(cornerRadius: 42,
                                                     dimmingViewAlpha: 31,
                                                     edgeInsets: .zero)

        XCTAssertEqual(subject.presentationOptions, expectedPresentationOptions)
    }

    func testThatCreatingAPresentationControllerUsesPresentationOptions() {

        let presentingViewController = UIViewController()
        let presentedViewController = UIViewController()
        let source = UIViewController()

        let presentationOptions = BottomSheetPresentationOptions(
            cornerRadius: 42,
            dimmingViewAlpha: 31,
            edgeInsets: .zero)

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

    }

}

class BottomSheetPresentationManagerTests: XCTestCase {

    var subject: BottomSheetPresentationManager!

    override func setUp() {
        super.setUp()
        subject = BottomSheetPresentationManager()
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
