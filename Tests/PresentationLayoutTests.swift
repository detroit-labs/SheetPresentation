//
//  PresentationLayoutTests.swift
//  SheetPresentationTests
//
//  Created by Jeff Kelley on 8/6/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import SheetPresentation
import XCTest

final class PresentationLayoutTests: XCTestCase {

    func testTheLayoutsAreInitialized() {
        let layout = PresentationLayout(horizontalLayout: .fill,
                                        verticalLayout: .fill)

        XCTAssertEqual(layout.horizontalLayout, .fill)
        XCTAssertEqual(layout.verticalLayout, .fill)
    }

}
