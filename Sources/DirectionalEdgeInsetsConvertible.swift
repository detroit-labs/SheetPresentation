//
//  DirectionalEdgeInsetsConvertible.swift
//  SheetPresentation
//
//  Created by Jeff Kelley on 5/10/19.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import UIKit

public protocol DirectionalEdgeInsetsConvertible {

    @available(iOS 11.0, macCatalyst 10.15, *)
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

@available(iOS 11.0, macCatalyst 10.15, *)
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

    @available(iOS 11.0, macCatalyst 10.15, *)
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
