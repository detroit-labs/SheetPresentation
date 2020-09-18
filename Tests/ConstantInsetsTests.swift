//
//  ConstantInsetsTests.swift
//  SheetPresentationTests
//
//  Created by Jeff Kelley on 8/6/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import SheetPresentation
import UIKit
import XCTest

final class ConstantInsetsTests: XCTestCase {

    func testGlobalConstantInsetsMethod() {
        XCTAssertEqual(constantInsets(42),
                       UIEdgeInsets(top: 42, left: 42, bottom: 42, right: 42))
    }

    func testCreatingUIEdgeInsetsWithAConstant() {
        XCTAssertEqual(UIEdgeInsets(constant: 42),
                       UIEdgeInsets(top: 42, left: 42, bottom: 42, right: 42))
    }

    func testCreatingUIEdgeInsetsWithTwoConstants() {
        XCTAssertEqual(UIEdgeInsets(verticalConstant: 42,
                                    horizontalConstant: 100),
                       UIEdgeInsets(top: 42, left: 100, bottom: 42, right: 100))
    }

    func testCreatingNSDirectionalEdgeInsetsWithAConstant() throws {
        guard #available(iOS 11.0, macCatalyst 10.15, *) else {
            throw XCTSkip("NSDirectionalEdgeInsets unavailable")
        }

        XCTAssertEqual(
            NSDirectionalEdgeInsets(constant: 42),
            NSDirectionalEdgeInsets(top: 42,
                                    leading: 42,
                                    bottom: 42,
                                    trailing: 42)
        )
    }

    func testCreatingNSDirectionalEdgeInsetsWithTwoConstants() throws {
        guard #available(iOS 11.0, macCatalyst 10.15, *) else {
            throw XCTSkip("NSDirectionalEdgeInsets unavailable")
        }

        XCTAssertEqual(
            NSDirectionalEdgeInsets(verticalConstant: 42,
                                    horizontalConstant: 100),
            NSDirectionalEdgeInsets(top: 42,
                                    leading: 100,
                                    bottom: 42,
                                    trailing: 100)
        )
    }

}
