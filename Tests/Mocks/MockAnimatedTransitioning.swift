//
//  MockAnimatedTransitioning.swift
//  SheetPresentationTests
//
//  Created by Jeff Kelley on 8/21/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import UIKit

class MockAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        0
    }

    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {

    }

}
