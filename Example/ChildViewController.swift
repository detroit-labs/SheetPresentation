//
//  ChildViewController.swift
//  SheetPresentation
//
//  Created by Jeff Kelley on 7/17/18.
//  Copyright © 2020 Detroit Labs, LLC. All rights reserved.
//

import UIKit

class ChildViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var contentView: UIView?
    @IBOutlet weak var stackView: UIStackView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment to see how a preferred content size is handled.
        // preferredContentSize = CGSize(width: 200, height: 500)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }

    override func traitCollectionDidChange(
        _ previousTraitCollection: UITraitCollection?
    ) {
        super.traitCollectionDidChange(previousTraitCollection)
    }

}
