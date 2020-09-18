//
//  ConstantInsets.swift
//  SheetPresentation
//
//  Created by Jeff Kelley on 8/6/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import UIKit

public protocol ConstantInsets {

    /// Initializes the insets with a constant value for all dimensions.
    ///
    /// - Parameter constant: The constant value to use for all dimensions.
    init(constant: CGFloat)

    init(verticalConstant: CGFloat, horizontalConstant: CGFloat)
}

@available(iOS 11.0, macCatalyst 10.15, *)
extension NSDirectionalEdgeInsets: ConstantInsets {

    public init(constant: CGFloat) {
        self.init(top: constant,
                  leading: constant,
                  bottom: constant,
                  trailing: constant)
    }

    public init(verticalConstant: CGFloat, horizontalConstant: CGFloat) {
        self.init(top: verticalConstant,
                  leading: horizontalConstant,
                  bottom: verticalConstant,
                  trailing: horizontalConstant)
    }

}

extension UIEdgeInsets: ConstantInsets {

    public init(constant: CGFloat) {
        self.init(top: constant,
                  left: constant,
                  bottom: constant,
                  right: constant)
    }

    public init(verticalConstant: CGFloat, horizontalConstant: CGFloat) {
        self.init(top: verticalConstant,
                  left: horizontalConstant,
                  bottom: verticalConstant,
                  right: horizontalConstant)
    }

}

public func constantInsets(_ constant: CGFloat) -> UIEdgeInsets {
    UIEdgeInsets(constant: constant)
}
