//
//  ViewEdgeTests.swift
//  BottomSheetPresentationTests
//
//  Created by Jeff Kelley on 9/11/19.
//  Copyright © 2019 Detroit Labs. All rights reserved.
//

import XCTest
@testable import BottomSheetPresentation

class ViewEdgeTests: XCTestCase {

    func testViewEdgesContainThemselves() {
        XCTAssertTrue(UIView.Edge.top.contains(.top))
        XCTAssertTrue(UIView.Edge.left.contains(.left))
        XCTAssertTrue(UIView.Edge.right.contains(.right))
        XCTAssertTrue(UIView.Edge.bottom.contains(.bottom))
    }

    func testStaticMembersContainIndividualItems() {
        XCTAssertTrue(UIView.Edge.all.contains(.top))
        XCTAssertTrue(UIView.Edge.all.contains(.left))
        XCTAssertTrue(UIView.Edge.all.contains(.right))
        XCTAssertTrue(UIView.Edge.all.contains(.bottom))

        XCTAssertTrue(UIView.Edge.bottomEdges.contains(.left))
        XCTAssertTrue(UIView.Edge.bottomEdges.contains(.right))
        XCTAssertTrue(UIView.Edge.bottomEdges.contains(.bottom))
    }

}
