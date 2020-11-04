//
//  ViewEdgeConvertibleTests.swift
//  SheetPresentationTests
//
//  Created by Jeff Kelley on 9/11/19.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import SheetPresentation
import UIKit
import XCTest

extension FixedViewEdge: CaseIterable {
    public static var allCases: [FixedViewEdge] = [.top, .left, .right, .bottom]
}

extension DirectionalViewEdge: CaseIterable {
    public static var allCases: [DirectionalViewEdge] = [.top,
                                                         .leading,
                                                         .trailing,
                                                         .bottom]
}

final class ViewEdgeConvertibleTests: XCTestCase {

    func testFixedViewEdgesAreEqual() {
        for edge: ViewEdgeConvertible in FixedViewEdge.allCases {
            XCTAssertTrue(edge == edge)
        }
    }

    func testDirectionalViewEdgesAreEqual() {
        for edge: ViewEdgeConvertible in DirectionalViewEdge.allCases {
            XCTAssertTrue(edge == edge)
        }
    }

    func testFixedViewEdgesSometimesEqualDirectionalViewEdges() {
        XCTAssertTrue(FixedViewEdge.top == DirectionalViewEdge.top)
        XCTAssertFalse(FixedViewEdge.left == DirectionalViewEdge.leading)
        XCTAssertFalse(FixedViewEdge.right == DirectionalViewEdge.trailing)
        XCTAssertTrue(FixedViewEdge.bottom == DirectionalViewEdge.bottom)
    }

}

final class FixedViewEdgeTests: XCTestCase {

    func testFixedViewEdgesDoNotChangeWhenConvertingToThemselves() {
        for edge in FixedViewEdge.allCases {
            XCTAssertEqual(edge.fixedViewEdge(using: nil), edge)
        }
    }

    func testFixedViewEdgesDoNotChangeWhenConvertingToThemselvesWhenLTR() {
        let traits = UITraitCollection(layoutDirection: .leftToRight)

        for edge in FixedViewEdge.allCases {
            XCTAssertEqual(edge.fixedViewEdge(using: traits), edge)
        }
    }

    func testFixedViewEdgesDoNotChangeWhenConvertingToThemselvesWhenRTL() {
        let traits = UITraitCollection(layoutDirection: .rightToLeft)

        for edge in FixedViewEdge.allCases {
            XCTAssertEqual(edge.fixedViewEdge(using: traits), edge)
        }
    }

    func testFixedViewEdgesConvertToDirectionalViewEdges() {
        XCTAssertEqual(FixedViewEdge.top.directionalViewEdge(using: nil),
                       DirectionalViewEdge.top)

        XCTAssertEqual(FixedViewEdge.left.directionalViewEdge(using: nil),
                       DirectionalViewEdge.leading)

        XCTAssertEqual(FixedViewEdge.right.directionalViewEdge(using: nil),
                       DirectionalViewEdge.trailing)

        XCTAssertEqual(FixedViewEdge.bottom.directionalViewEdge(using: nil),
                       DirectionalViewEdge.bottom)
    }

    func testFixedViewEdgesConvertToDirectionalViewEdgesWhenLeftToRight() {
        let traits = UITraitCollection(layoutDirection: .leftToRight)

        XCTAssertEqual(FixedViewEdge.top.directionalViewEdge(using: traits),
                       DirectionalViewEdge.top)

        XCTAssertEqual(FixedViewEdge.left.directionalViewEdge(using: traits),
                       DirectionalViewEdge.leading)

        XCTAssertEqual(FixedViewEdge.right.directionalViewEdge(using: traits),
                       DirectionalViewEdge.trailing)

        XCTAssertEqual(FixedViewEdge.bottom.directionalViewEdge(using: traits),
                       DirectionalViewEdge.bottom)
    }

    func testFixedViewEdgesConvertToDirectionalViewEdgesWhenRightToLeft() {
        let traits = UITraitCollection(layoutDirection: .rightToLeft)

        XCTAssertEqual(FixedViewEdge.top.directionalViewEdge(using: traits),
                       DirectionalViewEdge.top)

        XCTAssertEqual(FixedViewEdge.left.directionalViewEdge(using: traits),
                       DirectionalViewEdge.trailing)

        XCTAssertEqual(FixedViewEdge.right.directionalViewEdge(using: traits),
                       DirectionalViewEdge.leading)

        XCTAssertEqual(FixedViewEdge.bottom.directionalViewEdge(using: traits),
                       DirectionalViewEdge.bottom)
    }

}

final class DirectionalViewEdgeTests: XCTestCase {

    func testDirectionalViewEdgesDoNotChangeWhenConvertingToThemselves() {
        for edge in DirectionalViewEdge.allCases {
            XCTAssertEqual(edge.directionalViewEdge(using: nil), edge)
        }
    }

    func testFixedViewEdgesDoNotChangeWhenConvertingToThemselvesWhenLTR() {
        let traits = UITraitCollection(layoutDirection: .leftToRight)

        for edge in DirectionalViewEdge.allCases {
            XCTAssertEqual(edge.directionalViewEdge(using: traits), edge)
        }
    }

    func testFixedViewEdgesDoNotChangeWhenConvertingToThemselvesWhenRTL() {
        let traits = UITraitCollection(layoutDirection: .rightToLeft)

        for edge in DirectionalViewEdge.allCases {
            XCTAssertEqual(edge.directionalViewEdge(using: traits), edge)
        }
    }

    func testDirectionalViewEdgesConvertToFixedViewEdges() {
        XCTAssertEqual(
            DirectionalViewEdge.top.fixedViewEdge(using: nil),
            FixedViewEdge.top
        )

        XCTAssertEqual(
            DirectionalViewEdge.leading.fixedViewEdge(using: nil),
            FixedViewEdge.left
        )

        XCTAssertEqual(
            DirectionalViewEdge.trailing.fixedViewEdge(using: nil),
            FixedViewEdge.right
        )

        XCTAssertEqual(
            DirectionalViewEdge.bottom.fixedViewEdge(using: nil),
            FixedViewEdge.bottom
        )
    }

    func testDirectionalViewEdgesConvertToFixedViewEdgesWhenLeftToRight() {
        let traits = UITraitCollection(layoutDirection: .leftToRight)

        XCTAssertEqual(DirectionalViewEdge.top.fixedViewEdge(using: traits),
                       FixedViewEdge.top)

        XCTAssertEqual(DirectionalViewEdge.leading.fixedViewEdge(using: traits),
                       FixedViewEdge.left)

        XCTAssertEqual(
            DirectionalViewEdge.trailing.fixedViewEdge(using: traits),
            FixedViewEdge.right
        )

        XCTAssertEqual(DirectionalViewEdge.bottom.fixedViewEdge(using: traits),
                       FixedViewEdge.bottom)
    }

    func testDirectionalViewEdgesConvertToFixedViewEdgesWhenRightToLeft() {
        let traits = UITraitCollection(layoutDirection: .rightToLeft)

        XCTAssertEqual(DirectionalViewEdge.top.fixedViewEdge(using: traits),
                       FixedViewEdge.top)

        XCTAssertEqual(DirectionalViewEdge.leading.fixedViewEdge(using: traits),
                       FixedViewEdge.right)

        XCTAssertEqual(
            DirectionalViewEdge.trailing.fixedViewEdge(using: traits),
            FixedViewEdge.left
        )

        XCTAssertEqual(DirectionalViewEdge.bottom.fixedViewEdge(using: traits),
                       FixedViewEdge.bottom)
    }

}
