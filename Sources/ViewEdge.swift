//
//  ViewEdge.swift
//  SheetPresentation
//
//  Created by Jon Shier on 6/29/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

/// An `OptionSet` representing the edges of an on-screen view.
public struct ViewEdge: OptionSet {

    /// All four edges of a view.
    public static let all: ViewEdge = [.top, .left, .right, .bottom]
    /// The bottom, left, and right edges of a view.
    public static let bottomEdges: ViewEdge = [.left, .right, .bottom]

    public static let none = ViewEdge(rawValue: 0 << 0)
    public static let top = ViewEdge(rawValue: 1 << 0)
    public static let left = ViewEdge(rawValue: 1 << 1)
    public static let right = ViewEdge(rawValue: 1 << 2)
    public static let bottom = ViewEdge(rawValue: 1 << 3)

    public let rawValue: UInt

    public init(rawValue: UInt) { self.rawValue = rawValue }

}
