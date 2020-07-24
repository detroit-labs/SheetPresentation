//
//  AnimationBehavior.swift
//  SheetPresentation
//
//  Created by Jeff Kelley on 7/23/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import UIKit

public enum AnimationBehavior {
    case system
    case present(edgeForAppearance: ViewEdge, edgeForDismissal: ViewEdge)
    case custom(UIViewControllerAnimatedTransitioning)
}
