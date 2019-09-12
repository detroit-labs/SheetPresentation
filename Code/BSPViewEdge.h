//
//  BSPViewEdge.h
//  BottomSheetPresentation
//
//  Created by Jeff Kelley on 9/11/19.
//  Copyright © 2019 Detroit Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, BSPViewEdge) {
    BSPViewEdgeNone   = 0,
    BSPViewEdgeTop    = 1 << 0,
    BSPViewEdgeLeft   = 1 << 1,
    BSPViewEdgeRight  = 1 << 2,
    BSPViewEdgeBottom = 1 << 3
} NS_SWIFT_NAME(ViewEdge);

NS_SWIFT_NAME(ViewEdge.all)
static BSPViewEdge const BSPViewEdgeAll = (BSPViewEdgeTop |
                                           BSPViewEdgeLeft |
                                           BSPViewEdgeRight |
                                           BSPViewEdgeBottom);

NS_SWIFT_NAME(ViewEdge.bottomEdges)
static BSPViewEdge const BSPViewEdgeBottomEdges = (BSPViewEdgeLeft |
                                                   BSPViewEdgeRight |
                                                   BSPViewEdgeBottom);
