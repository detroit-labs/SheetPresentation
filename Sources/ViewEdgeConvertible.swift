//
//  ViewEdgeConvertible.swift
//  SheetPresentation
//
//  Created by Jon Shier on 6/29/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import UIKit

/// A type that can convert between fixed and directional view edges.
public protocol ViewEdgeConvertible {

    /// Converts the type to fixed view edges.
    /// - Parameter traitCollection: The traits to use to determine layout
    ///                              direction.
    func fixedViewEdge(
        using traitCollection: UITraitCollection?
    ) -> FixedViewEdge

    /// Converts the type to directional view edges.
    /// - Parameter traitCollection: The traits to use to determine layout
    ///                              direction.
    func directionalViewEdge(
        using traitCollection: UITraitCollection?
    ) -> DirectionalViewEdge

}

private let ltrTraits = UITraitCollection(layoutDirection: .leftToRight)
private let rtlTraits = UITraitCollection(layoutDirection: .rightToLeft)

/// Determines if two `ViewEdgeConvertible` values are equivalent.
/// - Parameters:
///   - lhs: The first `ViewEdgeConvertible` value.
///   - rhs: The second `ViewEdgeConvertible` value.
/// - Returns: `true` if the values are equivalent in both left-to-right and
///            right-to-left triat collections.
public func == (_ lhs: ViewEdgeConvertible,
                _ rhs: ViewEdgeConvertible) -> Bool {
    switch (lhs.fixedViewEdge(using: ltrTraits),
            lhs.fixedViewEdge(using: rtlTraits)) {
    case (rhs.fixedViewEdge(using: ltrTraits),
          rhs.fixedViewEdge(using: rtlTraits)):
        return true
    default:
        return false
    }
}

/// A view edge relative to a fixed physical edge of the screen.
public enum FixedViewEdge: Equatable {

    /// The top edge.
    case top

    /// The left edge.
    case left

    /// The right edge.
    case right

    /// The bottom edge.
    case bottom

}

extension FixedViewEdge: ViewEdgeConvertible {

    public func fixedViewEdge(
        using traitCollection: UITraitCollection?
    ) -> FixedViewEdge {
        self
    }

    public func directionalViewEdge(
        using traitCollection: UITraitCollection?
    ) -> DirectionalViewEdge {
        switch (self, traitCollection?.layoutDirection) {
        case (.top, _): return .top
        case (.left, .rightToLeft): return .trailing
        case (.left, _): return .leading
        case (.right, .rightToLeft): return .leading
        case (.right, _): return .trailing
        case (.bottom, _): return .bottom
        }
    }

}

/// A view edge relative to the layout direction of on-screen text.
public enum DirectionalViewEdge: Equatable {

    /// The top edge.
    case top

    /// The leading edge.
    case leading

    /// The trailing edge.
    case trailing

    /// The bottom edge.
    case bottom

}

extension DirectionalViewEdge: ViewEdgeConvertible {

    public func fixedViewEdge(
        using traitCollection: UITraitCollection?
    ) -> FixedViewEdge {
        switch (self, traitCollection?.layoutDirection) {
        case (.top, _): return .top
        case (.leading, .rightToLeft): return .right
        case (.leading, _): return .left
        case (.trailing, .rightToLeft): return .left
        case (.trailing, _): return .right
        case (.bottom, _): return .bottom
        }
    }

    public func directionalViewEdge(
        using traitCollection: UITraitCollection?
    ) -> DirectionalViewEdge {
        self
    }

}
