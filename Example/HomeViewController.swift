//
//  HomeViewController.swift
//  SheetPresentation
//
//  Created by Jeff Kelley on 7/17/18.
//  Copyright © 2018 Detroit Labs, LLC. All rights reserved.
//

import UIKit
import BottomSheetPresentation

class HomeViewController: UIViewController {

    lazy var bottomSheetPresentationManager = BottomSheetPresentationManager()

    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.transitioningDelegate = bottomSheetPresentationManager
        segue.destination.modalPresentationStyle = .custom
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }

}
