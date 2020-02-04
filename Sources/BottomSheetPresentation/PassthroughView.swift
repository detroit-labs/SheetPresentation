//
//  PassthroughView.swift
//  BottomSheetPresentation
//
//  Created by Jeff Kelley on 9/11/19.
//  Copyright © 2019 Detroit Labs. All rights reserved.
//

import UIKit

class PassthroughView: UIView {

    var passthroughViews: [UIView] = []

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var hit = super.hitTest(point, with: event)

        if hit == self {
            for view in passthroughViews {
                hit = view.hitTest(point, with: event)

                if hit != nil {
                    break
                }
            }
        }

        return hit
    }

}
