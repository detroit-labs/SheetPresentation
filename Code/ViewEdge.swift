//
//  ViewEdge.swift
//  BottomSheetPresentation
//
//  Created by Jeff Kelley on 9/10/19.
//  Copyright © 2019 Detroit Labs. All rights reserved.
//

import UIKit

extension UIView {

    /// A side of a view. Can include top, left, right, or bottom in any
    /// combination.
    @objcMembers
    @objc(BSPViewEdge)
    public class Edge: NSObject, OptionSet {

        /// The raw value of the edge. Used internally.
        @nonobjc public let rawValue: Int

        /// The top edge of the view.
        public static let top      = Edge(rawValue: 1 << 0)

        /// The left edge of the view.
        public static let left     = Edge(rawValue: 1 << 1)

        /// The right edge of the view.
        public static let right    = Edge(rawValue: 1 << 2)

        /// The bottom edge of the view.
        public static let bottom   = Edge(rawValue: 1 << 3)

        /// Creates an edge with a raw value. Used internally.
        ///
        /// - Parameter rawValue: The raw value to use.
        @nonobjc required public init(rawValue: Int) {
            self.rawValue = rawValue
            super.init()
        }

        /// All of the view’s edges.
        public static let all: Edge = [.top, .left, .right, .bottom]

        /// The bottom edge and both side edges of a view.
        public static let bottomEdges: Edge = [.left, .right, .bottom]

        /// No edges.
        public static let none: Edge = []

        // MARK: - NSObject Lifecycle

        /// Creates a new edge.
        @nonobjc required public convenience override init() {
            self.init(rawValue: 0)
        }

        /// The hash value of the edge.
        @nonobjc override public var hash: Int {
            return rawValue.hashValue
        }

        /// Evaluates another object for equality.
        ///
        /// - Parameter object: The other object
        /// - Returns: `true` if the other object is an `Edge` with the same
        ///            `rawValue`.
        @nonobjc public override func isEqual(_ object: Any?) -> Bool {
            guard let object = object as? Edge else { return false }

            return rawValue == object.rawValue
        }

    }

}
