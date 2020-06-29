//
//  SheetPresentationTests.swift
//  SheetPresentationTests
//
//  Created by Jeff Kelley on 7/19/18.
//  Copyright © 2020 Detroit Labs, LLC. All rights reserved.
//

import XCTest
@testable import SheetPresentation

final class SheetPresentationOptionsTests: XCTestCase {

    func testThatTheDefaultInitUsesDefaultPresentationOptions() {
        let subject = SheetPresentationManager()
        XCTAssertEqual(subject.presentationOptions, .default)
    }

    func testThatInitWithPresentationOptionsUsesThoseOptions() {
        let presentationOptions = SheetPresentationOptions(
            cornerRadius: 42,
            dimmingViewAlpha: 31,
            edgeInsets: .zero)

        let subject = SheetPresentationManager(
            options: presentationOptions)

        XCTAssertEqual(subject.presentationOptions, presentationOptions)
    }

    func testThatInitWithPresentationValuesUsesThoseValues() {
        let expectedPresentationOptions = SheetPresentationOptions(
            cornerRadius: 42,
            dimmingViewAlpha: 31,
            edgeInsets: .zero,
            ignoredEdgesForMargins: [])

        let subject = SheetPresentationManager(cornerRadius: 42,
                                                     dimmingViewAlpha: 31,
                                                     edgeInsets: .zero)

        XCTAssertEqual(subject.presentationOptions, expectedPresentationOptions)
    }

    func testThatCreatingAPresentationControllerUsesPresentationOptions() {

        let presentingViewController = UIViewController()
        let presentedViewController = UIViewController()
        let source = UIViewController()

        let presentationOptions = SheetPresentationOptions(
            cornerRadius: 42,
            dimmingViewAlpha: 31,
            edgeInsets: .zero)

        let subject = SheetPresentationManager(
            options: presentationOptions)

        let presentationController = subject.presentationController(
            forPresented: presentedViewController,
            presenting: presentingViewController,
            source: source) as! SheetPresentationController

        XCTAssertEqual(presentationController.cornerOptions,
                       presentationOptions.cornerOptions)

        XCTAssertEqual(presentationController.dimmingViewAlpha,
                       presentationOptions.dimmingViewAlpha)

        XCTAssertEqual(presentationController.edgeInsets,
                       presentationOptions.edgeInsets)

    }

}

class SheetPresentationManagerTests: XCTestCase {

    var subject: SheetPresentationManager!

    override func setUp() {
        super.setUp()
        subject = SheetPresentationManager()
    }

    func createPresentationControllerWithMockVCs(
        ) -> SheetPresentationController {
        return subject.presentationController(
            forPresented: UIViewController(),
            presenting: UIViewController(),
            source: UIViewController()) as! SheetPresentationController
    }

}

final class SPMTransitioningDelegateTests: SheetPresentationManagerTests {

    func testThatCreatedPresentationControllersHaveTheirDelegateSet() {

        XCTAssertTrue(
            createPresentationControllerWithMockVCs().delegate === subject
        )

    }

}

final class SPMAdaptivePCDelegateTests: SheetPresentationManagerTests {

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

final class SheetPresentationControllerTests: XCTestCase {

    var subject: SheetPresentationController!

    override func setUp() {
        super.setUp()

        subject = SheetPresentationController(
            forPresented: UIViewController(),
            presenting: UIViewController())
    }

    func testThatSettingCornerRadiusUpdatesLayoutContainer() throws {
        subject.cornerOptions = .roundAllCorners(radius: 42)

        let layoutContainer = try XCTUnwrap(subject.layoutContainer)

        XCTAssertEqual(layoutContainer.layer.cornerRadius,
                       42)
        XCTAssertTrue(layoutContainer.clipsToBounds)

        if #available(iOS 11.0, *) {
            XCTAssertEqual(layoutContainer.layer.maskedCorners, .all)
        }
    }

    func testThatSettingMaskedCornerRadiusUpdatesLayoutContainer() throws {
        guard #available(iOS 11.0, *) else {
           throw XCTSkip()
        }

        subject.cornerOptions = .roundSomeCorners(radius: 42, corners: .top)

        let layoutContainer = try XCTUnwrap(subject.layoutContainer)

        XCTAssertEqual(layoutContainer.layer.cornerRadius,
                       42)
        XCTAssertTrue(layoutContainer.clipsToBounds)

        XCTAssertEqual(layoutContainer.layer.maskedCorners, .top)
    }

    func testThatRoundingNoCornersDoesNotMaskLayoutContainer() throws {
        subject.cornerOptions = .none

        let layoutContainer = try XCTUnwrap(subject.layoutContainer)

        XCTAssertEqual(layoutContainer.layer.cornerRadius, 0)
        XCTAssertFalse(layoutContainer.clipsToBounds)

        if #available(iOS 11.0, *) {
            XCTAssertEqual(layoutContainer.layer.maskedCorners, .all)
        }
    }

    func testThatSettingDimmingViewAlphaUpdatesDimmingView() {
        subject.dimmingViewAlpha = 0.42

        var alpha: CGFloat = 0
        subject.dimmingView?.backgroundColor?.getWhite(nil, alpha: &alpha)

        XCTAssertEqual(alpha, 0.42)
    }

    func testThatUpdatingEdgeInsetsUpdatesLayout() {
        class MockView: UIView {
            var didNeedLayout = false

            override func setNeedsLayout() {
                super.setNeedsLayout()
                didNeedLayout = true
            }
        }

        let layoutContainer = MockView()
        subject.layoutContainer = layoutContainer

        let edgeInsets = UIEdgeInsets(constant: 42)
        subject.edgeInsets = edgeInsets

        XCTAssertTrue(layoutContainer.didNeedLayout)
    }

    func testThatTheLayoutContainerIsThePresentedView() {
        XCTAssertEqual(subject.presentedView, subject.layoutContainer)
    }

    func testCallingTheDimmingViewDismissalBlockHandler() {
        var passedInViewController: UIViewController! = nil

        let expect = expectation(description: "tap handler fired")

        subject = SheetPresentationController(
            forPresented: UIViewController(),
            presenting: UIViewController(),
            dimmingViewTapHandler: .block({ (viewController) in
                passedInViewController = viewController
                expect.fulfill()
            }))

        let presentedViewController = subject.presentedViewController

        // Manually fire the target/action for the gesture recognizer attached
        // to the dimming view.
        subject.userTappedInDimmingArea(UITapGestureRecognizer())

        waitForExpectations(timeout: 2)

        XCTAssertEqual(passedInViewController, presentedViewController)
    }

    var receivedViewController: UIViewController!

    func receiveViewController(sender: UIViewController) {
        receivedViewController = sender
    }

    func testCallingTheDimmingViewDismissalTargetActionHandler() {

        subject = SheetPresentationController(
            forPresented: UIViewController(),
            presenting: UIViewController(),
            dimmingViewTapHandler: .targetAction(
                self, #selector(receiveViewController(sender:))))

        let presentedViewController = subject.presentedViewController

        // Manually fire the target/action for the gesture recognizer attached
        // to the dimming view.
        subject.userTappedInDimmingArea(UITapGestureRecognizer())

        XCTAssertEqual(receivedViewController, presentedViewController)

    }

}
