//
//  UIEdgeInsetsHelpers.swift
//  SheetPresentation
//
//  Created by Jeff Kelley on 5/10/19.
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

@available(iOS 11.0, *)
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

public protocol DirectionalEdgeInsetsConvertible {

    @available(iOS 11.0, *)
    func directionalEdgeInsets(
        for traitCollection: UITraitCollection?
    ) -> NSDirectionalEdgeInsets

    func fixedEdgeInsets(
        for traitCollection: UITraitCollection?
    ) -> UIEdgeInsets

}

public func == (lhs: DirectionalEdgeInsetsConvertible,
                rhs: DirectionalEdgeInsetsConvertible) -> Bool {
    return lhs.fixedEdgeInsets(for: nil) ==
        rhs.fixedEdgeInsets(for: nil)
}

@available(iOS 11.0, *)
extension NSDirectionalEdgeInsets: DirectionalEdgeInsetsConvertible {

    public func directionalEdgeInsets(
        for traitCollection: UITraitCollection?
    ) -> NSDirectionalEdgeInsets {
        self
    }

    public func fixedEdgeInsets(
        for traitCollection: UITraitCollection?
    ) -> UIEdgeInsets {
        switch traitCollection?.layoutDirection {
        case .rightToLeft:
            return UIEdgeInsets(top: top,
                                left: trailing,
                                bottom: bottom,
                                right: leading)
        default:
            return UIEdgeInsets(top: top,
                                left: leading,
                                bottom: bottom,
                                right: trailing)
        }
    }

}

extension UIEdgeInsets: DirectionalEdgeInsetsConvertible {

    @available(iOS 11.0, *)
    public func directionalEdgeInsets(
        for traitCollection: UITraitCollection?
    ) -> NSDirectionalEdgeInsets {
        switch traitCollection?.layoutDirection {
        case .rightToLeft:
            return NSDirectionalEdgeInsets(top: top,
                                           leading: right,
                                           bottom: bottom,
                                           trailing: left)
        default:
            return NSDirectionalEdgeInsets(top: top,
                                           leading: left,
                                           bottom: bottom,
                                           trailing: right)
        }
    }

    public func fixedEdgeInsets(
        for traitCollection: UITraitCollection?
    ) -> UIEdgeInsets {
        self
    }

}

public extension UIEdgeInsets {

    /// Forms a union with the given edge insets. Each value in the insets will
    /// be the larger of the two values.
    ///
    /// - Parameter otherInsets: The other insets with which to form a union.
    mutating func formUnion(with otherInsets: UIEdgeInsets) {
        top = max(top, otherInsets.top)
        left = max(left, otherInsets.left)
        bottom = max(bottom, otherInsets.bottom)
        right = max(right, otherInsets.right)
    }

}
