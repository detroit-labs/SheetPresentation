//
//  UIViewAnimationOptionsHelpersTests.swift
//  SheetPresentationTests
//
//  Created by Jeff Kelley on 8/7/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

@testable import SheetPresentation

import UIKit
import XCTest

final class UIViewAnimationOptionsHelpersTests: XCTestCase {

    func testConvertingFromAnimationCurvesToAnimationOptions() {
        XCTAssertEqual(UIView.AnimationOptions(curve: .easeInOut),
                       .curveEaseInOut)

        XCTAssertEqual(UIView.AnimationOptions(curve: .easeIn), .curveEaseIn)
        XCTAssertEqual(UIView.AnimationOptions(curve: .easeOut), .curveEaseOut)
        XCTAssertEqual(UIView.AnimationOptions(curve: .linear), .curveLinear)

        XCTAssertEqual(UIView.AnimationOptions(curve: nil), [])
    }

}
