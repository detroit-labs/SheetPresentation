//
//  UIViewController+PreferredContentSize.swift
//  BottomSheetPresentation
//
//  Created by Jeff Kelley on 5/10/19.
//  Copyright © 2019 Detroit Labs. All rights reserved.
//

import UIKit

extension UIViewController {

    /// Returns `true` if the `width` and `height` of the view controller’s
    /// `preferredContentSize` are both larger than `0`.
    var hasPreferredContentSize: Bool {
        return preferredContentSize.width > 0 && preferredContentSize.height > 0
    }

}
