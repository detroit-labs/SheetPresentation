//
//  SheetPresentationOptionsTests.swift
//  SheetPresentationTests
//
//  Created by Jeff Kelley on 8/21/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

@testable import SheetPresentation

import UIKit
import XCTest

final class SheetPresentationOptionsTests: XCTestCase {

    func testApplyingRoundAllCornersOptionsToView() {
        let view = UIView()

        let options = SheetPresentationOptions.CornerOptions.roundAllCorners(
            radius: 20
        )

        options.apply(to: view)

        XCTAssertTrue(view.clipsToBounds)
        XCTAssertEqual(view.layer.cornerRadius, 20)

        if #available(iOS 11.0, macCatalyst 10.15, *) {
            XCTAssertEqual(view.layer.maskedCorners, .all)
        }
    }

    func testApplyingRoundSomeCornersOptionsToView() throws {
        guard #available(iOS 11.0, macCatalyst 10.15, *) else {
            throw XCTSkip("roundSomeCorners unavailable")
        }

        let view = UIView()

        let options = SheetPresentationOptions.CornerOptions.roundSomeCorners(
            radius: 20,
            corners: .top
        )

        options.apply(to: view)

        XCTAssertTrue(view.clipsToBounds)
        XCTAssertEqual(view.layer.cornerRadius, 20)
        XCTAssertEqual(view.layer.maskedCorners, .top)
    }

    func testApplyingRoundNoCornersOptionsToView() {
        let view = UIView()

        let options = SheetPresentationOptions.CornerOptions.none

        options.apply(to: view)

        XCTAssertFalse(view.clipsToBounds)
        XCTAssertEqual(view.layer.cornerRadius, 0)
    }

}
