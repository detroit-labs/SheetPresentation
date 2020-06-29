//
//  CACornerMaskHelpers.swift
//  SheetPresentation
//
//  Created by Jeff Kelley on 9/11/19.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import UIKit

public extension CACornerMask {

    /// A mask of all four corners.
    static let all: CACornerMask = [layerMaxXMaxYCorner,
                                    layerMaxXMinYCorner,
                                    layerMinXMaxYCorner,
                                    layerMinXMinYCorner]

    /// A mask of the top two corners.
    static let top: CACornerMask = [layerMinXMinYCorner,
                                    layerMaxXMinYCorner]

    /// A mask of the bottom two corners.
    static let bottom: CACornerMask = [layerMinXMaxYCorner,
                                       layerMaxXMaxYCorner]

    /// A mask of the left two corners.
    static let left: CACornerMask = [layerMinXMinYCorner,
                                     layerMinXMaxYCorner]

    /// A mask of the right two corners.
    static let right: CACornerMask = [layerMaxXMinYCorner,
                                      layerMaxXMaxYCorner]

}
