//
//  MockSizableViewController.swift
//  SheetPresentationTests
//
//  Created by Jeff Kelley on 8/25/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import UIKit

extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}

private class MockSizableView: UIView {

    struct SizeAndPriority: Hashable {
        let size: CGSize
        let horizontalFittingPriority: UILayoutPriority
        let verticalFittingPriority: UILayoutPriority
    }

    var layoutSizeForTargetSizeAndPriority: [SizeAndPriority: CGSize] = [:]

    override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        // swiftlint:disable:next line_length
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority
    ) -> CGSize {
        let sizeAndPriority = SizeAndPriority(
            size: targetSize,
            horizontalFittingPriority: horizontalFittingPriority,
            verticalFittingPriority: verticalFittingPriority
        )

        return layoutSizeForTargetSizeAndPriority[sizeAndPriority] ?? .zero
    }

}

class MockSizableViewController: MockViewController {

    override func loadView() {
        view = MockSizableView()
    }

    func set(layoutSize size: CGSize,
             forTargetSize targetSize: CGSize,
             horizontalFittingPriority: UILayoutPriority,
             verticalFittingPriority: UILayoutPriority) {
        let sizeAndPriority = MockSizableView.SizeAndPriority(
            size: targetSize,
            horizontalFittingPriority: horizontalFittingPriority,
            verticalFittingPriority: verticalFittingPriority
        )

        (view as! MockSizableView)
            .layoutSizeForTargetSizeAndPriority[sizeAndPriority] = size
    }

}
