//
//  ViewEdge.swift
//  SheetPresentation
//
//  Created by Jon Shier on 6/29/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import UIKit

public protocol ViewEdge {

    func fixedViewEdge(
        using traitCollection: UITraitCollection?
    ) -> FixedViewEdge

}

public enum FixedViewEdge: ViewEdge {

    case top
    case left
    case right
    case bottom

    public func fixedViewEdge(
        using traitCollection: UITraitCollection?
    ) -> FixedViewEdge {
        self
    }

}

public enum DirectionalViewEdge: ViewEdge {

    case top
    case leading
    case trailing
    case bottom

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

}
