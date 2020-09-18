//
//  UIViewAnimationOptionsHelpers.swift
//  SheetPresentation
//
//  Created by Jeff Kelley on 7/21/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import UIKit

extension UIView.AnimationOptions {

    init(curve: UIView.AnimationCurve?) {
        switch curve {
        case .easeInOut:
            self = [.curveEaseInOut]
        case .easeIn:
            self = [.curveEaseIn]
        case .easeOut:
            self = [.curveEaseOut]
        case .linear:
            self = [.curveLinear]
        default:
            self = []
        }
    }

}
