//
//  NSLayoutConstraintHelpers.swift
//  BottomSheetPresentation
//
//  Created by Jeff Kelley on 5/10/19.
//  Copyright © 2019 Detroit Labs. All rights reserved.
//

import UIKit

public extension NSLayoutConstraint {

    /// Create an array of constraints using an ASCII art-like visual format
    /// string.
    ///
    /// - Parameters:
    ///   - format: The visual format string.
    ///   - views: A dictionary that maps view identifiers in `format` with
    ///            view objects.
    /// - Returns: An `Array` of `NSLayoutConstraint`s to satisfy the format.
    class func constraints(withVisualFormat format: String,
                           views: [String: Any]) -> [NSLayoutConstraint] {
        return self.constraints(withVisualFormat: format,
                                options: [],
                                metrics: nil,
                                views: views)
    }

    /// Convenience method that activates each constraint in the contained
    /// arrays, in the same manner as setting `active=YES` on each constraint.
    /// This is often more efficient than activating each constraint
    /// individually.
    ///
    /// - Parameter constraintArrays: An array of arrays containing
    ///                               `NSLayoutConstraint`s.
    class func activate(_ constraintArrays: [[NSLayoutConstraint]]) {
        self.activate(constraintArrays.flatMap { $0 })
    }

}
