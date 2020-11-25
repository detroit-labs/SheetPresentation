//
//  AnimationBehaviorTests.swift
//  SheetPresentationTests
//
//  Created by Jeff Kelley on 8/5/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import SheetPresentation
import UIKit
import XCTest

final class AnimationBehaviorTests: XCTestCase {

    func testSystemAnimationsAreEqual() {
        XCTAssertEqual(AnimationBehavior.system, AnimationBehavior.system)
    }

    func testSystemAnimationDoesNotEqualEdgePresentation() {
        XCTAssertNotEqual(
            AnimationBehavior.system,
            AnimationBehavior.present(edgeForAppearance: FixedViewEdge.top,
                                      edgeForDismissal: FixedViewEdge.top)
        )
    }

    func testSytemAnimationDoesNotEqualCustomPresentation() {
        XCTAssertNotEqual(
            AnimationBehavior.system,
            AnimationBehavior.custom(appearance: MockAnimator(),
                                     dismissal: MockAnimator())
        )
    }

    func testFixedEdgePresentationsAreEqual() {
        XCTAssertEqual(
            AnimationBehavior.present(edgeForAppearance: FixedViewEdge.top,
                                      edgeForDismissal: FixedViewEdge.top),
            AnimationBehavior.present(edgeForAppearance: FixedViewEdge.top,
                                      edgeForDismissal: FixedViewEdge.top)
        )

        XCTAssertEqual(
            AnimationBehavior.present(edgeForAppearance: FixedViewEdge.left,
                                      edgeForDismissal: FixedViewEdge.left),
            AnimationBehavior.present(edgeForAppearance: FixedViewEdge.left,
                                      edgeForDismissal: FixedViewEdge.left)
        )

        XCTAssertEqual(
            AnimationBehavior.present(edgeForAppearance: FixedViewEdge.right,
                                      edgeForDismissal: FixedViewEdge.right),
            AnimationBehavior.present(edgeForAppearance: FixedViewEdge.right,
                                      edgeForDismissal: FixedViewEdge.right)
        )

        XCTAssertEqual(
            AnimationBehavior.present(edgeForAppearance: FixedViewEdge.bottom,
                                      edgeForDismissal: FixedViewEdge.bottom),
            AnimationBehavior.present(edgeForAppearance: FixedViewEdge.bottom,
                                      edgeForDismissal: FixedViewEdge.bottom)
        )
    }

    func testDirectionalEdgePresentationsAreEqual() {
        XCTAssertEqual(
            AnimationBehavior.present(
                edgeForAppearance: DirectionalViewEdge.top,
                edgeForDismissal: DirectionalViewEdge.top
            ),
            AnimationBehavior.present(
                edgeForAppearance: DirectionalViewEdge.top,
                edgeForDismissal: DirectionalViewEdge.top
            )
        )

        XCTAssertEqual(
            AnimationBehavior.present(
                edgeForAppearance: DirectionalViewEdge.leading,
                edgeForDismissal: DirectionalViewEdge.leading
            ),
            AnimationBehavior.present(
                edgeForAppearance: DirectionalViewEdge.leading,
                edgeForDismissal: DirectionalViewEdge.leading
            )
        )

        XCTAssertEqual(
            AnimationBehavior.present(
                edgeForAppearance: DirectionalViewEdge.trailing,
                edgeForDismissal: DirectionalViewEdge.trailing
            ),
            AnimationBehavior.present(
                edgeForAppearance: DirectionalViewEdge.trailing,
                edgeForDismissal: DirectionalViewEdge.trailing
            )
        )

        XCTAssertEqual(
            AnimationBehavior.present(
                edgeForAppearance: DirectionalViewEdge.bottom,
                edgeForDismissal: DirectionalViewEdge.bottom
            ),
            AnimationBehavior.present(
                edgeForAppearance: DirectionalViewEdge.bottom,
                edgeForDismissal: DirectionalViewEdge.bottom
            )
        )
    }

    func testFixedEdgePresentationsEqualDirectionalEdgePresentations() {
        XCTAssertEqual(
            AnimationBehavior.present(
                edgeForAppearance: FixedViewEdge.top,
                edgeForDismissal: FixedViewEdge.top
            ),
            AnimationBehavior.present(
                edgeForAppearance: DirectionalViewEdge.top,
                edgeForDismissal: DirectionalViewEdge.top
            )
        )

        XCTAssertEqual(
            AnimationBehavior.present(
                edgeForAppearance: FixedViewEdge.left,
                edgeForDismissal: FixedViewEdge.left
            ),
            AnimationBehavior.present(
                edgeForAppearance: DirectionalViewEdge.leading,
                edgeForDismissal: DirectionalViewEdge.leading
            )
        )

        XCTAssertEqual(
            AnimationBehavior.present(
                edgeForAppearance: FixedViewEdge.right,
                edgeForDismissal: FixedViewEdge.right
            ),
            AnimationBehavior.present(
                edgeForAppearance: DirectionalViewEdge.trailing,
                edgeForDismissal: DirectionalViewEdge.trailing
            )
        )

        XCTAssertEqual(
            AnimationBehavior.present(
                edgeForAppearance: FixedViewEdge.bottom,
                edgeForDismissal: FixedViewEdge.bottom
            ),
            AnimationBehavior.present(
                edgeForAppearance: DirectionalViewEdge.bottom,
                edgeForDismissal: DirectionalViewEdge.bottom
            )
        )
    }

    func testCustomAnimationsThatAreEqual() {
        let appearanceAnimator = MockAnimator()
        let dismissalAnimator = MockAnimator()

        XCTAssertEqual(AnimationBehavior.custom(appearance: appearanceAnimator,
                                                dismissal: dismissalAnimator),
                       AnimationBehavior.custom(appearance: appearanceAnimator,
                                                dismissal: dismissalAnimator))
    }

    func testCustomAnimationsThatAreNotEqual() {
        XCTAssertNotEqual(AnimationBehavior.custom(appearance: MockAnimator(),
                                                   dismissal: MockAnimator()),
                          AnimationBehavior.custom(appearance: MockAnimator(),
                                                   dismissal: MockAnimator()))
    }

    func testCustomAnimationsThatArePartiallyEqual() {
        let appearanceAnimator = MockAnimator()

        XCTAssertNotEqual(
            AnimationBehavior.custom(appearance: appearanceAnimator,
                                     dismissal: MockAnimator()),
            AnimationBehavior.custom(appearance: appearanceAnimator,
                                     dismissal: MockAnimator())
        )

        let dismissalAnimator = MockAnimator()

        XCTAssertNotEqual(
            AnimationBehavior.custom(appearance: MockAnimator(),
                                     dismissal: dismissalAnimator),
            AnimationBehavior.custom(appearance: MockAnimator(),
                                     dismissal: dismissalAnimator)
        )
    }

}
