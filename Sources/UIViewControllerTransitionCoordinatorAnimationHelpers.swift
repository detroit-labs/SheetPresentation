//
//  UIViewControllerTransitionCoordinatorAnimationHelpers.swift
//  SheetPresentation
//
//  Created by Jeff Kelley on 7/21/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import UIKit

private let defaultAnimationDuration: TimeInterval = 1.0 / 3.0

extension UIViewControllerTransitionCoordinator {

    typealias CoordinatorContext = UIViewControllerTransitionCoordinatorContext
    typealias Animation = (CoordinatorContext?) -> Void
    typealias Completion = (CoordinatorContext?) -> Void

    func animate(id animationID: String,
                 alongsideTransition animation: Animation?,
                 completion: Completion? = nil,
                 animationAPI api: UIView.Type = UIView.self) {
        // Despite this API being available earlier, iOS 11.3 is the first OS
        // that doesn’t just animate this instantly for dismissals.
        if #available(iOS 11.3, macCatalyst 10.15, *) {
            let success = animate(
                alongsideTransition: animation.map { animation in {
                    animation($0)
                }},
                completion: completion.map { completion in {
                    completion($0)
                }}
            )

            if success { return }
        }

        // If the above fails or we’re on iOS 11.2 or earlier, fall back to
        // legacy UIKit animation methods.
        let animationDuration: TimeInterval

        if transitionDuration > 0 {
            animationDuration = transitionDuration
        }
        else {
            animationDuration = defaultAnimationDuration
        }

        api.animate(
            withDuration: animationDuration,
            delay: 0,
            options: .init(curve: completionCurve),
            animations: { animation?(nil) },
            completion: { _ in completion?(nil) }
        )
    }

}
