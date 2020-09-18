//
//  PassthroughViewTests.swift
//  SheetPresentationTests
//
//  Created by Jeff Kelley on 8/6/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

@testable import SheetPresentation

import UIKit
import XCTest

final class PassthroughViewTests: XCTestCase {

    func testPassthroughViewReturnsSelfForHitTest() {
        let subject = PassthroughView(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: 100,
                                                    height: 100))

        XCTAssertEqual(subject.hitTest(CGPoint(x: 50, y: 50), with: nil),
                       subject)
    }

    func testPassthroughViewReturnsNilForHitTestOutsideItsBounds() {
        let subject = PassthroughView(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: 100,
                                                    height: 100))

        XCTAssertNil(subject.hitTest(CGPoint(x: 150, y: 150), with: nil))
    }

    func testPassthroughViewReturnsSpecifiedViewForHitTest() {
        let subject = PassthroughView(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: 100,
                                                    height: 100))

        let viewToPassTouchesThrough = UIView(frame: CGRect(x: 0,
                                                            y: 0,
                                                            width: 25,
                                                            height: 25))

        subject.passthroughViews.append(viewToPassTouchesThrough)

        XCTAssertEqual(subject.hitTest(CGPoint(x: 10, y: 10), with: nil),
                       viewToPassTouchesThrough)
    }

    func testPassthroughViewReturnsSpecifiedViewInOrderForHitTest() {
        let subject = PassthroughView(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: 100,
                                                    height: 100))

        let otherViewA = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: 100,
                                              height: 100))

        let otherViewB = UIView(frame: CGRect(x: 20,
                                              y: 20,
                                              width: 10,
                                              height: 10))

        let viewToPassTouchesThrough = UIView(frame: CGRect(x: 0,
                                                            y: 0,
                                                            width: 25,
                                                            height: 25))

        subject.passthroughViews = [otherViewB,
                                    viewToPassTouchesThrough,
                                    otherViewA]

        XCTAssertEqual(subject.hitTest(CGPoint(x: 10, y: 10), with: nil),
                       viewToPassTouchesThrough)

        XCTAssertEqual(subject.hitTest(CGPoint(x: 22, y: 22), with: nil),
                       otherViewB)

        XCTAssertEqual(subject.hitTest(CGPoint(x: 90, y: 90), with: nil),
                       otherViewA)
    }

}
