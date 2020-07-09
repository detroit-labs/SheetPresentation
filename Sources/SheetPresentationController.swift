//
//  SheetPresentationController.swift
//  SheetPresentation
//
//  Created by Jeff Kelley on 5/10/19.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import UIKit

final class SheetPresentationController: UIPresentationController {

    // MARK: - Presentation Options

    let options: SheetPresentationOptions

    var marginAdjustedEdgeInsets: UIEdgeInsets {
        var insets = options.edgeInsets
        let margins: UIEdgeInsets

        if #available(iOS 12, *), let containerView = containerView {
            margins = containerView.layoutMargins
        }
        else {
            margins = presentingViewController.view.safeAreaInsets
        }

        let ignoredEdgesForMargins = options.ignoredEdgesForMargins

        if !ignoredEdgesForMargins.contains(.top) {
            insets.top = max(insets.top, margins.top)
        }
        if !ignoredEdgesForMargins.contains(.left) {
            insets.left = max(insets.left, margins.left)
        }
        if !ignoredEdgesForMargins.contains(.right) {
            insets.right = max(insets.right, margins.right)
        }
        if !ignoredEdgesForMargins.contains(.bottom) {
            insets.bottom = max(insets.bottom, margins.bottom)
        }

        return insets
    }

    // MARK: - Interaction Options

    var dimmingViewTapHandler: DimmingViewTapHandler

    // MARK: - Initialization

    init(forPresented presented: UIViewController,
         presenting: UIViewController?,
         presentationOptions options: SheetPresentationOptions = .default,
         dimmingViewTapHandler: DimmingViewTapHandler = .default) {
        self.options = options
        self.dimmingViewTapHandler = dimmingViewTapHandler

        super.init(presentedViewController: presented, presenting: presenting)
    }

    // MARK: - Internal Subviews

    lazy var dimmingView: UIView? = {
        guard let alpha = options.dimmingViewAlpha else { return nil }

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
            .withAlphaComponent(alpha)

        view.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(userTappedInDimmingArea(_:))))

        return view
    }()

    lazy var passthroughView: PassthroughView? = {
        guard options.dimmingViewAlpha == nil,
            let presentedView = presentedView
            else { return nil }

        let view = PassthroughView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear

        view.passthroughViews = [presentedView]

        return view
    }()

    // MARK: - UIPresentationController Implementation

    override var frameOfPresentedViewInContainerView: CGRect {
        let maximumBounds = maximumPresentedBoundsInContainerView

        var size = preferredPresentedViewControllerSize(
            fitting: maximumBounds.size
        )

        // Constrain the width and height to the safe area of the container view
        size.height = min(size.height, maximumBounds.height)
        size.width = min(size.width, maximumBounds.width)

        var frame = maximumBounds

        switch options.presentationEdge {
        case .top:
            // Position the rect vertically at the top of the maximum bounds
            frame.origin.y = maximumBounds.minY
            frame.size.height = size.height

            // Center the rect horizontally inside the maximum bounds
            frame.origin.x = maximumBounds.minX +
                ((maximumBounds.width - size.width) / 2.0)

            frame.size.width = size.width
        case .leading:
            frame.origin.y = maximumBounds.minY
            frame.origin.x = maximumBounds.minX
            frame.size = size
        case .trailing:
            frame.origin.y = maximumBounds.minY
            frame.origin.x = maximumBounds.origin.x
            frame.size = size
        case .bottom:
            // Position the rect vertically at the bottom of the maximum bounds
            frame.origin.y = maximumBounds.maxY - size.height
            frame.size.height = size.height

            // Center the rect horizontally inside the maximum bounds
            frame.origin.x = maximumBounds.minX +
                ((maximumBounds.width - size.width) / 2.0)

            frame.size.width = size.width
        }

        return frame.integral
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        guard let containerView = containerView else { return }

        dimmingView?.frame = containerView.bounds
        passthroughView?.frame = containerView.bounds

        if let presentedView = presentedView {
            options.cornerOptions.apply(to: presentedView)
        }
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        layoutDimmingView()
        layoutPassthroughView()

        animateDimmingViewAppearing()
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        animateDimmingViewDisappearing()
    }

    override var shouldPresentInFullscreen: Bool { false }

    // MARK: - Internal Implementation

    var maximumPresentedBoundsInContainerView: CGRect {
        containerView?.bounds.inset(by: marginAdjustedEdgeInsets) ?? .zero
    }

    func preferredPresentedViewControllerSize(fitting size: CGSize) -> CGSize {
        if presentedViewController.hasPreferredContentSize {
            return presentedViewController.preferredContentSize
        }

        switch options.presentationEdge {
        case .bottom, .top:
            return presentedViewController.view.systemLayoutSizeFitting(
                size,
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )
        case .leading, .trailing:
            return presentedViewController.view.systemLayoutSizeFitting(
                size,
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .required
            )
        }
    }

    func layoutDimmingView() {
        guard let containerView = containerView,
              let dimmingView = dimmingView
        else { return }

        containerView.insertSubview(dimmingView, at: 0)
        dimmingView.frame = containerView.bounds
    }

    func layoutPassthroughView() {
        guard let containerView = containerView,
              let passthroughView = passthroughView
        else { return }

        containerView.insertSubview(passthroughView, at: 0)
        passthroughView.frame = containerView.bounds
    }

    func animateDimmingViewAppearing() {
        guard let dimmingView = dimmingView,
              let transitionCoordinator = presentedViewController
                .transitionCoordinator
        else { return }

        dimmingView.alpha = 0

        transitionCoordinator.animate(alongsideTransition: { _ in
            dimmingView.alpha = 1
        })
    }

    func animateDimmingViewDisappearing() {
        guard let dimmingView = dimmingView,
              let transitionCoordinator = presentedViewController
                .transitionCoordinator
        else { return }

        // Despite this API being available earlier, iOS 11.3 is the first OS
        // that doesn’t just animate this instantly.
        if #available(iOS 11.3, *) {
            transitionCoordinator.animateAlongsideTransition(
                in: dimmingView.superview,
                animation: { _ in dimmingView.alpha = 0 },
                completion: { _ in dimmingView.removeFromSuperview() }
            )
        }
        else {
            UIView.beginAnimations("animateDimmingViewDisappearing",
                                   context: nil)

            if transitionCoordinator.transitionDuration > 0 {
                UIView.setAnimationDuration(
                    transitionCoordinator.transitionDuration
                )
            }
            else {
                UIView.setAnimationDuration(1.0 / 3.0)
            }

            UIView.setAnimationCurve(transitionCoordinator.completionCurve)

            dimmingView.alpha = 0

            UIView.commitAnimations()
        }
    }

    // MARK: - UI Interaction

    @objc func userTappedInDimmingArea(
        _ gestureRecognizer: UITapGestureRecognizer
    ) {
        switch dimmingViewTapHandler {
        case let .block(handler):
            handler(presentedViewController)
        case let .targetAction(target, action):
            target.perform(action, with: presentedViewController)
        }
    }

}
