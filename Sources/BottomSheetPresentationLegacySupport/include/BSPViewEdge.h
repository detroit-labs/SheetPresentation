//
//  BSPViewEdge.h
//  BottomSheetPresentation
//
//  Created by Jeff Kelley on 9/11/19.
//  Copyright © 2019 Detroit Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

    /// An option type representing the sides of an on-screen view.
    typedef NS_OPTIONS(NSUInteger, BSPViewEdge) {
        
        /// No edges
        BSPViewEdgeNone   = 0,
        
        /// The top edge of the view
        BSPViewEdgeTop    = 1 << 0,
        
        /// The left edge of the view
        BSPViewEdgeLeft   = 1 << 1,
        
        /// The right edge of the view
        BSPViewEdgeRight  = 1 << 2,
        
        /// The bottom edge of the view
        BSPViewEdgeBottom = 1 << 3
        
    } NS_SWIFT_NAME(ViewEdge);

    /// All four edges of a view.
    NS_SWIFT_NAME(ViewEdge.all)
    static BSPViewEdge const BSPViewEdgeAll = (BSPViewEdgeTop |
                                               BSPViewEdgeLeft |
                                               BSPViewEdgeRight |
                                               BSPViewEdgeBottom);

    /// The bottom, left, and right edges of a view.
    NS_SWIFT_NAME(ViewEdge.bottomEdges)
    static BSPViewEdge const BSPViewEdgeBottomEdges = (BSPViewEdgeLeft |
                                                       BSPViewEdgeRight |
                                                       BSPViewEdgeBottom);
