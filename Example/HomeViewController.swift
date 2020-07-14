//
//  HomeViewController.swift
//  SheetPresentation
//
//  Created by Jeff Kelley on 7/17/18.
//  Copyright © 2020 Detroit Labs, LLC. All rights reserved.
//

import UIKit
import SheetPresentation

class HomeViewController: UIViewController {

    lazy var bottomSheetPresentationManager: SheetPresentationManager = {
        let options = SheetPresentationOptions(
            cornerOptions: .roundAllCorners(radius: 8),
            dimmingViewAlpha: 0.5,
            edgeInsets: UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        )

        return SheetPresentationManager(options: options)
    }()

    lazy var modalPresentationManager: SheetPresentationManager = {
        let options = SheetPresentationOptions(
            cornerOptions: .none,
            dimmingViewAlpha: 0.5,
            edgeInsets: .zero,
            ignoredEdgesForMargins: .all,
            presentationLayout: .overlay()
        )

        return SheetPresentationManager(options: options)
    }()

    lazy var leadingSheetPresentationManager: SheetPresentationManager = {
        let options = SheetPresentationOptions(
            cornerOptions: .roundSomeCorners(radius: 10, corners: .right),
            dimmingViewAlpha: 0.5,
            edgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 100),
            ignoredEdgesForMargins: [.top, .leading, .bottom],
            presentationLayout: .leading(.fill)
        )

        return SheetPresentationManager(options: options)
    }()

    lazy var trailingSheetPresentationManager: SheetPresentationManager = {
        let options = SheetPresentationOptions(
            cornerOptions: .roundSomeCorners(radius: 10, corners: .left),
            dimmingViewAlpha: 0.5,
            edgeInsets: UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 0),
            ignoredEdgesForMargins: [.top, .trailing, .bottom],
            presentationLayout: .trailing(.fill)
        )

        return SheetPresentationManager(options: options)
    }()

    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "presentLeading":
            segue.destination.transitioningDelegate =
                leadingSheetPresentationManager
        case "presentTrailing":
            segue.destination.transitioningDelegate =
                trailingSheetPresentationManager
        case "presentBottom":
            segue.destination.transitioningDelegate =
                bottomSheetPresentationManager
        default:
            fatalError("Unrecognized segue identifier.")
        }

        segue.destination.modalPresentationStyle = .custom
    }

    @IBAction func presentModally(_ sender: Any) {
        let controller = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "ChildViewController")
        controller.transitioningDelegate = modalPresentationManager
        controller.modalPresentationStyle = .custom

        present(controller, animated: true, completion: nil)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }

}
