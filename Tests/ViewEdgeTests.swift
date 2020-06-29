//
//  ViewEdgeTests.swift
//  SheetPresentationTests
//
//  Created by Jeff Kelley on 9/11/19.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import XCTest
@testable import SheetPresentation

final class ViewEdgeTests: XCTestCase {

    func testViewEdgesContainThemselves() {
        XCTAssertTrue(ViewEdge.top.contains(.top))
        XCTAssertTrue(ViewEdge.left.contains(.left))
        XCTAssertTrue(ViewEdge.right.contains(.right))
        XCTAssertTrue(ViewEdge.bottom.contains(.bottom))
    }

    func testStaticMembersContainIndividualItems() {
        XCTAssertTrue(ViewEdge.all.contains(.top))
        XCTAssertTrue(ViewEdge.all.contains(.left))
        XCTAssertTrue(ViewEdge.all.contains(.right))
        XCTAssertTrue(ViewEdge.all.contains(.bottom))

        XCTAssertFalse(ViewEdge.bottomEdges.contains(.top))
        XCTAssertTrue(ViewEdge.bottomEdges.contains(.left))
        XCTAssertTrue(ViewEdge.bottomEdges.contains(.right))
        XCTAssertTrue(ViewEdge.bottomEdges.contains(.bottom))
    }

}
