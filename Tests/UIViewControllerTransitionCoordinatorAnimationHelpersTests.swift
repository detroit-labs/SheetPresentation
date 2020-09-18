//
//  UIViewControllerTransitionCoordinatorAnimationHelpersTests.swift
//  SheetPresentationTests
//
//  Created by Jeff Kelley on 8/6/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

@testable import SheetPresentation
import UIKit
import XCTest

private class MockAnimationAPI: UIView {

    static var receivedDuration: TimeInterval?
    static var receivedDelay: TimeInterval?
    static var receivedOptions: UIView.AnimationOptions?

    static override func animate(withDuration duration: TimeInterval,
                                 delay: TimeInterval,
                                 options: UIView.AnimationOptions = [],
                                 animations: @escaping () -> Void,
                                 completion: ((Bool) -> Void)? = nil) {
        receivedDuration = duration
        receivedDelay = delay
        receivedOptions = options

        DispatchQueue.main.async {
            animations()
            completion?(true)
        }
    }

}

// swiftlint:disable:next line_length type_name
final class UIViewControllerTransitionCoordinatorAnimationHelpersTests: XCTestCase {

    func testSuccessfulAnimation() throws {
        guard #available(iOS 11.3, macCatalyst 10.15, *) else {
            throw XCTSkip()
        }

        let coordinator = MockTransitionCoordinator()
        coordinator.executeAnimationsAutomatically = true

        let closureExpectation = self.expectation(
            description: "The closures fire."
        )

        closureExpectation.expectedFulfillmentCount = 2

        coordinator.animate(
            id: UUID().uuidString,
            alongsideTransition: { _ in closureExpectation.fulfill() },
            completion: { _ in closureExpectation.fulfill() }
        )

        waitForExpectations(timeout: 2)
    }

    func testLegacyAnimation() {
        let coordinator = MockTransitionCoordinator()

        if #available(iOS 11.3, macCatalyst 10.15, *) {
            // The legacy animation code path is triggered if the transition
            // coordinator returns false for
            // animate(alongsideTransition:completion:).
            coordinator.forceLegacyPath = true
        }

        let closureExpectation = self.expectation(
            description: "The closures fire."
        )

        closureExpectation.expectedFulfillmentCount = 2

        coordinator.animate(
            id: UUID().uuidString,
            alongsideTransition: { _ in closureExpectation.fulfill() },
            completion: { _ in closureExpectation.fulfill() },
            animationAPI: MockAnimationAPI.self
        )

        waitForExpectations(timeout: 2)

        XCTAssertEqual(MockAnimationAPI.receivedDuration,
                       coordinator.transitionDuration)

        XCTAssertEqual(MockAnimationAPI.receivedDelay, 0)

        XCTAssertEqual(MockAnimationAPI.receivedOptions,
                       .init(curve: coordinator.completionCurve))
    }

    func testLegacyAnimationWithDefaultDuration() {
        let coordinator = MockTransitionCoordinator()
        coordinator.transitionDuration = 0

        if #available(iOS 11.3, macCatalyst 10.15, *) {
            // The legacy animation code path is triggered if the transition
            // coordinator returns false for
            // animate(alongsideTransition:completion:).
            coordinator.forceLegacyPath = true
        }

        let closureExpectation = self.expectation(
            description: "The closures fire."
        )

        closureExpectation.expectedFulfillmentCount = 2

        coordinator.animate(
            id: UUID().uuidString,
            alongsideTransition: { _ in closureExpectation.fulfill() },
            completion: { _ in closureExpectation.fulfill() },
            animationAPI: MockAnimationAPI.self
        )

        waitForExpectations(timeout: 2)

        XCTAssertEqual(MockAnimationAPI.receivedDuration, 1.0 / 3.0)

        XCTAssertEqual(MockAnimationAPI.receivedDelay, 0)

        XCTAssertEqual(MockAnimationAPI.receivedOptions,
                       .init(curve: coordinator.completionCurve))
    }

}
