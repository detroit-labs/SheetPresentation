//
//  SheetPresentationManagerTests.swift
//  SheetPresentationTests
//
//  Created by Jeff Kelley on 8/21/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

@testable import SheetPresentation

import UIKit
import XCTest

extension UIUserInterfaceSizeClass: CaseIterable {

    public static var allCases: [UIUserInterfaceSizeClass] = [
        .compact,
        .regular
    ]

}

final class SheetPresentationManagerTests: XCTestCase {

    func testCreatingASheetPresentationController() {
        let viewController = UIViewController()
        let source = UIViewController()

        let subject = SheetPresentationManager()

        let presentationController = subject.presentationController(
            forPresented: viewController,
            presenting: nil,
            source: source
        )

        XCTAssertEqual(presentationController?.delegate as? NSObject, subject)
    }

    func testThePresentationManagerAlwaysPresentsOverCurrentContext() throws {
        let viewController = UIViewController()
        let source = UIViewController()

        let subject = SheetPresentationManager()

        let presentationController = try XCTUnwrap(
            subject.presentationController(forPresented: viewController,
                                           presenting: nil,
                                           source: source)
        )

        XCTAssertEqual(
            subject.adaptivePresentationStyle(for: presentationController),
            .overCurrentContext
        )

        for horizontalSizeClass in UIUserInterfaceSizeClass.allCases {
            let horizontalTraitCollection = UITraitCollection(
                horizontalSizeClass: horizontalSizeClass
            )

            for verticalSizeClass in UIUserInterfaceSizeClass.allCases {
                let verticalTraitCollection = UITraitCollection(
                    verticalSizeClass: verticalSizeClass
                )

                let combinedTraits = UITraitCollection.init(traitsFrom: [
                    horizontalTraitCollection, verticalTraitCollection
                ])

                XCTAssertEqual(
                    subject.adaptivePresentationStyle(
                        for: presentationController,
                        traitCollection: combinedTraits
                    ),
                    .overCurrentContext
                )
            }
        }
    }

    func testCreatingASheetAnimationControllerForPresenting() throws {
        let presentedViewController = UIViewController()
        let presentingViewController = UIViewController()
        let sourceViewController = UIViewController()

        let subject = SheetPresentationManager(
            options: SheetPresentationOptions(
                animationBehavior: .present(
                    edgeForAppearance: FixedViewEdge.bottom,
                    edgeForDismissal: FixedViewEdge.bottom
                )
            )
        )

        let animator = try XCTUnwrap(
            subject.animationController(forPresented: presentedViewController,
                                        presenting: presentingViewController,
                                        source: sourceViewController)
                as? SheetAnimationController
        )

        XCTAssertEqual(animator.edge.fixedViewEdge(using: nil), .bottom)
        XCTAssertTrue(animator.isPresenting)
    }

    func testCreatingASheetAnimationControllerForDismissing() throws {
        let dismissedViewController = UIViewController()

        let subject = SheetPresentationManager(
            options: SheetPresentationOptions(
                animationBehavior: .present(
                    edgeForAppearance: FixedViewEdge.bottom,
                    edgeForDismissal: FixedViewEdge.bottom
                )
            )
        )

        let animator = try XCTUnwrap(
            subject.animationController(forDismissed: dismissedViewController)
                as? SheetAnimationController
        )

        XCTAssertEqual(animator.edge.fixedViewEdge(using: nil), .bottom)
        XCTAssertFalse(animator.isPresenting)
    }

    func testUsingTheSystemAnimationForPresenting() {
        let presentedViewController = UIViewController()
        let presentingViewController = UIViewController()
        let sourceViewController = UIViewController()

        let subject = SheetPresentationManager(
            options: SheetPresentationOptions(
                animationBehavior: .system
            )
        )

        XCTAssertNil(
            subject.animationController(forPresented: presentedViewController,
                                        presenting: presentingViewController,
                                        source: sourceViewController)
        )
    }

    func testUsingTheSystemAnimationForDismissing() {
        let dismissedViewController = UIViewController()

        let subject = SheetPresentationManager(
            options: SheetPresentationOptions(
                animationBehavior: .system
            )
        )

        XCTAssertNil(
            subject.animationController(forDismissed: dismissedViewController)
        )
    }

    func testUsingACustomAnimatorForPresenting() {
        let appearanceAnimator = MockAnimator()
        let dismissalAnimator = MockAnimator()
        let presentedViewController = UIViewController()
        let presentingViewController = UIViewController()
        let sourceViewController = UIViewController()

        let subject = SheetPresentationManager(
            options: SheetPresentationOptions(
                animationBehavior: .custom(appearance: appearanceAnimator,
                                           dismissal: dismissalAnimator)
            )
        )

        XCTAssertEqual(
            appearanceAnimator,
            subject.animationController(forPresented: presentedViewController,
                                        presenting: presentingViewController,
                                        source: sourceViewController)
                as? MockAnimator
        )
    }

    func testUsingACustomAnimatorForDismissing() {
        let appearanceAnimator = MockAnimator()
        let dismissalAnimator = MockAnimator()
        let dismissedViewController = UIViewController()

        let subject = SheetPresentationManager(
            options: SheetPresentationOptions(
                animationBehavior: .custom(appearance: appearanceAnimator,
                                           dismissal: dismissalAnimator)
            )
        )

        XCTAssertEqual(
            dismissalAnimator,
            subject.animationController(forDismissed: dismissedViewController)
                as? MockAnimator
        )
    }

}
