//
//  DirectionalEdgeInsetsConvertible.swift
//  SheetPresentation
//
//  Created by Jeff Kelley on 5/10/19.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import UIKit

/// A type that can be converted to directional or fixed edge insets.
public protocol DirectionalEdgeInsetsConvertible {

    /// Converts the value into `NSDirectionalEdgeInsets`.
    /// - Parameter traitCollection: The trait collection relative to which the
    ///                              direction is computed, using its
    ///                              `layoutDirection` property.
    @available(iOS 11.0, macCatalyst 10.15, *)
    func directionalEdgeInsets(
        for traitCollection: UITraitCollection?
    ) -> NSDirectionalEdgeInsets

    /// Converts the value into `UIEdgeInsets`.
    /// - Parameter traitCollection: The trait collection relative to which the
    ///                              direction is computed, using its
    ///                              `layoutDirection` property.
    func fixedEdgeInsets(
        for traitCollection: UITraitCollection?
    ) -> UIEdgeInsets

}

/// Determines if two `DirectionalEdgeInsetsConvertible` values are equivalent.
/// - Parameters:
///   - lhs: The first `DirectionalEdgeInsetsConvertible` value.
///   - rhs: The second `DirectionalEdgeInsetsConvertible` value.
/// - Returns: `true` if the `fixedEdgeInsets(for:)` method using a `nil` trait
///            collection returns the same `UIEdgeInsets` value for both `lhs`
///            and `rhs`.
public func == (_ lhs: DirectionalEdgeInsetsConvertible,
                _ rhs: DirectionalEdgeInsetsConvertible) -> Bool {
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
