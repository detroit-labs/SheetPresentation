//
//  MockViewController.swift
//  SheetPresentationTests
//
//  Created by Jeff Kelley on 8/25/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import UIKit
import XCTest

class MockViewController: UIViewController {

    var receivedSenderForAction: AnyObject?

    @objc func mockAction(_ sender: AnyObject?) {
        receivedSenderForAction = sender
    }

    // MARK: - UIViewController

    // MARK: dismiss(animated:completion:)

    var dismissWasAnimated: Bool?
    var dismissCompletion: (() -> Void)?

    override func dismiss(animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        dismissWasAnimated = flag
        dismissCompletion = completion

        super.dismiss(animated: flag, completion: completion)
    }

    // MARK: transitionCoordinator

    private var _transitionCoordinator: UIViewControllerTransitionCoordinator?

    override var transitionCoordinator: UIViewControllerTransitionCoordinator? {
        get { _transitionCoordinator ?? super.transitionCoordinator }
        set { _transitionCoordinator = newValue }
    }

    // MARK: - UIContentContainer

    // MARK: viewWillTransition(to:with:)

    var viewWillTransitionToSize: CGSize?
    var viewWillTransitionToCoordinator: UIViewControllerTransitionCoordinator?
    var viewWillTransitionToSizeExpectation: XCTestExpectation?

    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        viewWillTransitionToSize = size
        viewWillTransitionToCoordinator = coordinator

        super.viewWillTransition(to: size, with: coordinator)

        viewWillTransitionToSizeExpectation?.fulfill()
    }

    // MARK: willTransition(to:with:)

    var willTransitionToWithTraitCollection: UITraitCollection?
    var willTransitionToWithCoordinator: UIViewControllerTransitionCoordinator?
    var willTransitionToWithExpectation: XCTestExpectation?

    override func willTransition(
        to newCollection: UITraitCollection,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        willTransitionToWithTraitCollection = newCollection
        willTransitionToWithCoordinator = coordinator

        super.willTransition(to: newCollection, with: coordinator)

        willTransitionToWithExpectation?.fulfill()
    }

    // MARK: - UITraitEnvironment

    // MARK: traitCollectionDidChange(_:)

    // swiftlint:disable:next identifier_name
    var traitCollectionDidChangePreviousTraitCollection: UITraitCollection?
    var traitCollectionDidChangeExpectation: XCTestExpectation?

    override func traitCollectionDidChange(
        _ previousTraitCollection: UITraitCollection?
    ) {
        traitCollectionDidChangePreviousTraitCollection =
        previousTraitCollection

        traitCollectionDidChangeExpectation?.fulfill()
    }

}
