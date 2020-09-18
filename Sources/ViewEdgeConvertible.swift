//
//  ViewEdgeConvertible.swift
//  SheetPresentation
//
//  Created by Jon Shier on 6/29/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import UIKit

public protocol ViewEdgeConvertible {

    func fixedViewEdge(
        using traitCollection: UITraitCollection?
    ) -> FixedViewEdge

    func directionalViewEdge(
        using traitCollection: UITraitCollection?
    ) -> DirectionalViewEdge

}

private let ltrTraits = UITraitCollection(layoutDirection: .leftToRight)
private let rtlTraits = UITraitCollection(layoutDirection: .rightToLeft)

public func == (lhs: ViewEdgeConvertible, rhs: ViewEdgeConvertible) -> Bool {
    switch (lhs.fixedViewEdge(using: ltrTraits),
            lhs.fixedViewEdge(using: rtlTraits)) {
    case (rhs.fixedViewEdge(using: ltrTraits),
          rhs.fixedViewEdge(using: rtlTraits)):
        return true
    default:
        return false
    }
}

public enum FixedViewEdge: Equatable {

    case top
    case left
    case right
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

public enum DirectionalViewEdge: Equatable {

    case top
    case leading
    case trailing
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
