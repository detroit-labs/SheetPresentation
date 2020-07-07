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
            cornerRadius: 8,
            maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner],
            dimmingViewAlpha: nil,
            edgeInsets: .zero,
            ignoredEdgesForMargins: .bottomEdges
        )

        return SheetPresentationManager(options: options)
    }()

    lazy var modalPresentationManager: SheetPresentationManager = {
        let options = SheetPresentationOptions(
            cornerRadius: 0,
            maskedCorners: [],
            dimmingViewAlpha: 0,
            edgeInsets: .zero,
            ignoredEdgesForMargins: [.top, .bottom],
            presentationEdge: .trailing
        )

        return SheetPresentationManager(options: options)
    }()

    lazy var leadingSheetPresentationManager: SheetPresentationManager = {
        let options = SheetPresentationOptions(
            dimmingViewAlpha: nil,
            edgeInsets: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50),
            ignoredEdgesForMargins: .bottomEdges,
            presentationEdge: .leading
        )

        return SheetPresentationManager(options: options)
    }()

    lazy var trailingSheetPresentationManager: SheetPresentationManager = {
        let options = SheetPresentationOptions(
            dimmingViewAlpha: nil,
            edgeInsets: UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 0),
            ignoredEdgesForMargins: [.top, .right, .bottom],
            presentationEdge: .trailing
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
