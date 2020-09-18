//
//  DirectionalEdgeInsetsConvertibleTests.swift
//  SheetPresentationTests
//
//  Created by Jeff Kelley on 8/6/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import SheetPresentation
import UIKit
import XCTest

final class DirectionalEdgeInsetsConvertibleTests: XCTestCase {

    func testUIEdgeInsetsAreEqual() {
        let lhs: DirectionalEdgeInsetsConvertible = UIEdgeInsets(constant: 42)
        let rhs: DirectionalEdgeInsetsConvertible = UIEdgeInsets(constant: 42)

        XCTAssertTrue(lhs == rhs)
    }

    func testNSDirectionalEdgeInsetsAreEqual() throws {
        guard #available(iOS 11.0, macCatalyst 10.15, *) else {
            throw XCTSkip("NSDirectionalEdgeInsets unavailable")
        }

        let lhs: DirectionalEdgeInsetsConvertible =
            NSDirectionalEdgeInsets(constant: 42)

        let rhs: DirectionalEdgeInsetsConvertible =
            NSDirectionalEdgeInsets(constant: 42)

        XCTAssertTrue(lhs == rhs)
    }

    func testUIEdgeInsetsEqualNSDirectionalEdgeInsets() throws {
        guard #available(iOS 11.0, macCatalyst 10.15, *) else {
            throw XCTSkip("NSDirectionalEdgeInsets unavailable")
        }

        let lhs: DirectionalEdgeInsetsConvertible = UIEdgeInsets(constant: 42)

        let rhs: DirectionalEdgeInsetsConvertible =
            NSDirectionalEdgeInsets(constant: 42)

        XCTAssertTrue(lhs == rhs)
    }

}

final class UIEdgeInsetsConvertibleTests: XCTestCase {

    func testUIEdgeInsetsDoNotChangeWhenConvertingToThemselves() {
        let insets = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)

        XCTAssertEqual(insets.fixedEdgeInsets(for: nil), insets)
    }

    func testUIEdgeInsetsDoNotChangeWhenConvertingToThemselvesWhenLTR() {
        let insets = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        let traits = UITraitCollection(layoutDirection: .leftToRight)

        XCTAssertEqual(insets.fixedEdgeInsets(for: traits), insets)
    }

    func testUIEdgeInsetsDoNotChangeWhenConvertingToThemselvesWhenRTL() {
        let insets = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        let traits = UITraitCollection(layoutDirection: .rightToLeft)

        XCTAssertEqual(insets.fixedEdgeInsets(for: traits), insets)
    }

    func testUIEdgeInsetsConvertToNSDirectionalEdgeInsets() throws {
        guard #available(iOS 11.0, macCatalyst 10.15, *) else {
            throw XCTSkip("NSDirectionalEdgeInsets unavailable")
        }

        let insets = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)

        let expectedInsets = NSDirectionalEdgeInsets(top: 1,
                                                     leading: 2,
                                                     bottom: 3,
                                                     trailing: 4)

        XCTAssertEqual(insets.directionalEdgeInsets(for: nil), expectedInsets)
    }

    func testUIEdgeInsetsConvertToNSDirectionalEdgeInsetsWhenLTR() throws {
        guard #available(iOS 11.0, macCatalyst 10.15, *) else {
            throw XCTSkip("NSDirectionalEdgeInsets unavailable")
        }

        let insets = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)

        let expectedInsets = NSDirectionalEdgeInsets(top: 1,
                                                     leading: 2,
                                                     bottom: 3,
                                                     trailing: 4)

        let traits = UITraitCollection(layoutDirection: .leftToRight)

        XCTAssertEqual(insets.directionalEdgeInsets(for: traits),
                       expectedInsets)
    }

    func testUIEdgeInsetsConvertToNSDirectionalEdgeInsetsWhenRTL() throws {
        guard #available(iOS 11.0, macCatalyst 10.15, *) else {
            throw XCTSkip("NSDirectionalEdgeInsets unavailable")
        }

        let insets = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)

        let expectedInsets = NSDirectionalEdgeInsets(top: 1,
                                                     leading: 4,
                                                     bottom: 3,
                                                     trailing: 2)

        let traits = UITraitCollection(layoutDirection: .rightToLeft)

        XCTAssertEqual(insets.directionalEdgeInsets(for: traits),
                       expectedInsets)
    }

}

final class NSDirectionalEdgeInsetsConvertibleTests: XCTestCase {

    // swiftlint:disable:next line_length
    func testNSDirectionalEdgeInsetsDoNotChangeWhenConvertingToThemselves() throws {
        guard #available(iOS 11.0, macCatalyst 10.15, *) else {
            throw XCTSkip("NSDirectionalEdgeInsets unavailable")
        }

        let insets = NSDirectionalEdgeInsets(top: 1,
                                             leading: 2,
                                             bottom: 3,
                                             trailing: 4)

        XCTAssertEqual(insets.directionalEdgeInsets(for: nil), insets)
    }

    func testUIEdgeInsetsDoNotChangeWhenConvertingToThemselvesWhenLTR() throws {
        guard #available(iOS 11.0, macCatalyst 10.15, *) else {
            throw XCTSkip("NSDirectionalEdgeInsets unavailable")
        }

        let insets = NSDirectionalEdgeInsets(top: 1,
                                             leading: 2,
                                             bottom: 3,
                                             trailing: 4)

        let traits = UITraitCollection(layoutDirection: .leftToRight)

        XCTAssertEqual(insets.directionalEdgeInsets(for: traits), insets)
    }

    func testUIEdgeInsetsDoNotChangeWhenConvertingToThemselvesWhenRTL() throws {
        guard #available(iOS 11.0, macCatalyst 10.15, *) else {
            throw XCTSkip("NSDirectionalEdgeInsets unavailable")
        }

        let insets = NSDirectionalEdgeInsets(top: 1,
                                             leading: 2,
                                             bottom: 3,
                                             trailing: 4)

        let traits = UITraitCollection(layoutDirection: .rightToLeft)

        XCTAssertEqual(insets.directionalEdgeInsets(for: traits), insets)
    }

    func testNSDirectionalEdgeInsetsConvertToUIEdgeInsets() throws {
        guard #available(iOS 11.0, macCatalyst 10.15, *) else {
            throw XCTSkip("NSDirectionalEdgeInsets unavailable")
        }

        let insets = NSDirectionalEdgeInsets(top: 1,
                                             leading: 2,
                                             bottom: 3,
                                             trailing: 4)

        let expectedInsets = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)

        XCTAssertEqual(insets.fixedEdgeInsets(for: nil), expectedInsets)
    }

    // swiftlint:disable:next line_length
    func testNSDirectionalEdgeInsetsConvertToUIEdgeInsetsWhenLeftToRight() throws {
        guard #available(iOS 11.0, macCatalyst 10.15, *) else {
            throw XCTSkip("NSDirectionalEdgeInsets unavailable")
        }

        let insets = NSDirectionalEdgeInsets(top: 1,
                                             leading: 2,
                                             bottom: 3,
                                             trailing: 4)

        let expectedInsets = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)

        let traits = UITraitCollection(layoutDirection: .leftToRight)

        XCTAssertEqual(insets.fixedEdgeInsets(for: traits), expectedInsets)
    }

    // swiftlint:disable:next line_length
    func testNSDirectionalEdgeInsetsConvertToUIEdgeInsetsWhenRightToLeft() throws {
        guard #available(iOS 11.0, macCatalyst 10.15, *) else {
            throw XCTSkip("NSDirectionalEdgeInsets unavailable")
        }

        let insets = NSDirectionalEdgeInsets(top: 1,
                                             leading: 2,
                                             bottom: 3,
                                             trailing: 4)

        let expectedInsets = UIEdgeInsets(top: 1, left: 4, bottom: 3, right: 2)

        let traits = UITraitCollection(layoutDirection: .rightToLeft)

        XCTAssertEqual(insets.fixedEdgeInsets(for: traits), expectedInsets)
    }

}
