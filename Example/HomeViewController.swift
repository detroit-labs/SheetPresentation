//
//  HomeViewController.swift
//  SheetPresentation
//
//  Created by Jeff Kelley on 7/17/18.
//  Copyright © 2020 Detroit Labs, LLC. All rights reserved.
//

import UIKit
import BottomSheetPresentation

class HomeViewController: UIViewController {

    lazy var bottomSheetPresentationManager: BottomSheetPresentationManager = {
        let options: BottomSheetPresentationOptions

        if #available(iOS 11.0, *) {
            options = BottomSheetPresentationOptions(
                cornerRadius: 8,
                maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner],
                dimmingViewAlpha: nil,
                edgeInsets: .zero,
                ignoredEdgesForMargins: .bottomEdges
            )
        }
        else {
            options = BottomSheetPresentationOptions(
                cornerRadius: 8,
                dimmingViewAlpha: nil,
                edgeInsets: .zero,
                ignoredEdgesForMargins: .bottomEdges
            )
        }

        return BottomSheetPresentationManager(options: options)
    }()

    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.transitioningDelegate = bottomSheetPresentationManager
        segue.destination.modalPresentationStyle = .custom
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }

}
