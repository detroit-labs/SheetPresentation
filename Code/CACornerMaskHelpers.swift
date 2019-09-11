//
//  CACornerMaskHelpers.swift
//  BottomSheetPresentation
//
//  Created by Jeff Kelley on 9/11/19.
//  Copyright © 2019 Detroit Labs. All rights reserved.
//

import UIKit

extension CACornerMask {

    /// A mask of all four corners.
    public static let all: CACornerMask = [layerMaxXMaxYCorner,
                                           layerMaxXMinYCorner,
                                           layerMinXMaxYCorner,
                                           layerMinXMinYCorner]

    /// A mask of the top two corners.
    public static let top: CACornerMask = [layerMinXMinYCorner,
                                           layerMaxXMinYCorner]

    /// A mask of the bottom two corners.
    public static let bottom: CACornerMask = [layerMinXMaxYCorner,
                                              layerMaxXMaxYCorner]

    /// A mask of the left two corners.
    public static let left: CACornerMask = [layerMinXMinYCorner,
                                            layerMinXMaxYCorner]

    /// A mask of the right two corners.
    public static let right: CACornerMask = [layerMaxXMinYCorner,
                                             layerMaxXMaxYCorner]

}
