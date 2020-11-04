//
//  PassthroughView.swift
//  SheetPresentation
//
//  Created by Jeff Kelley on 9/11/19.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import UIKit

final class PassthroughView: UIView {

    var passthroughViews: [UIView] = []

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hit = super.hitTest(point, with: event)

        if hit == self {
            for view in passthroughViews {
                let convertedPoint = view.convert(point, from: self)

                if let hit = view.hitTest(convertedPoint, with: event) {
                    return hit
                }
            }
        }

        return hit
    }

}
