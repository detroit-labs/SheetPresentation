//
//  UIViewController+PreferredContentSizeTests.swift
//  SheetPresentationTests
//
//  Created by Jeff Kelley on 8/7/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import SheetPresentation
import UIKit
import XCTest

// swiftlint:disable:next type_name
final class UIViewController_PreferredContentSizeTests: XCTestCase {

    func testAViewControllerWithAPreferredContentSize() {
        let subject = UIViewController()
        subject.preferredContentSize = CGSize(width: 100, height: 100)
        XCTAssertTrue(subject.hasPreferredContentSize)
    }

    func testAViewControllerWithoutAPreferredContentSize() {
        let subject = UIViewController()
        subject.preferredContentSize = .zero
        XCTAssertFalse(subject.hasPreferredContentSize)
    }

}
