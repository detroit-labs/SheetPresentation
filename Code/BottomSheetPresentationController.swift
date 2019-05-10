//
//  BottomSheetPresentationController.swift
//  BottomSheetPresentation
//
//  Created by Jeff Kelley on 5/10/19.
//  Copyright © 2019 Detroit Labs. All rights reserved.
//

import UIKit

/// A presentation controller for presenting a view controller over the bottom
/// portion of the screen, automatically growing the view controller as needed
/// based on either its `preferredContentSize` or Auto Layout.
public final class BottomSheetPresentationController: UIPresentationController {

    // MARK: - Presentation Options

    internal var cornerRadius: CGFloat {
        didSet {
            if let layoutContainer = layoutContainer {
                layoutContainer.layer.cornerRadius = cornerRadius
            }
        }
    }

    internal var dimmingViewAlpha: CGFloat {
        didSet {
            if let dimmingView = dimmingView {
                dimmingView.backgroundColor = dimmingView.backgroundColor?
                    .withAlphaComponent(dimmingViewAlpha)
            }
        }
    }

    internal var edgeInsets: UIEdgeInsets {
        didSet {
            (containerView ?? presentedView)?.setNeedsLayout()
        }
    }

    // MARK: - Interaction Options

    internal var dimmingViewTapHandler: DimmingViewTapHandler

    // MARK: - Initialization

    /// Creates a `BottomSheetPresentationController` for a specific
    /// presentation.
    ///
    /// - Parameters:
    ///   - presented: The view controller being presented modally.
    ///   - presenting: The view controller whose content represents the
    ///                 starting point of the transition.
    ///   - options: The presentation options to use for presenting view
    ///              controllers.
    public init(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        presentationOptions options: BottomSheetPresentationOptions = .default,
        dimmingViewTapHandler: DimmingViewTapHandler = .default
        ) {
        cornerRadius = options.cornerRadius
        dimmingViewAlpha = options.dimmingViewAlpha
        edgeInsets = options.edgeInsets
        self.dimmingViewTapHandler = dimmingViewTapHandler

        super.init(presentedViewController: presented, presenting: presenting)
    }

    // MARK: - Private Subviews

    internal lazy var dimmingView: UIView? = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
            .withAlphaComponent(dimmingViewAlpha)

        view.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(userTappedInDimmingArea(_:))))

        return view
    }()

    internal lazy var layoutContainer: UIView? = {
        let view = UIView()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = true
        return view
    }()

    // MARK: - Public UIPresentationController Implementation

    override public var presentedView: UIView? { return layoutContainer }

    override public var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }

        let maximumBounds = maximumPresentedBoundsInContainerView

        var size = preferredPresentedViewControllerSize(in: maximumBounds)

        // Constrain the width and height to the safe area of the container view
        size.height = min(size.height, maximumBounds.height)
        size.width = min(size.width, maximumBounds.width)

        var frame = maximumBounds

        // Position the rect vertically at the bottom of the maximum bounds
        frame.origin.y = maximumBounds.maxY - size.height
        frame.size.height = size.height

        // Center the rect horizontally inside the container bounds
        frame.origin.x = (containerView.bounds.width - size.width) / 2.0
        frame.size.width = size.width

        return frame.integral
    }

    override public func containerViewWillLayoutSubviews() {
        guard let containerView = containerView else { return }
        dimmingView?.frame = containerView.bounds
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override public func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        layoutDimmingView()
        layoutLayoutContainer()

        animateDimmingViewAppearing()
    }

    override public func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        animateDimmingViewDisappearing()
    }

    public override var shouldPresentInFullscreen: Bool {
        return false
    }

    // MARK: - Private Implementation

    internal var maximumPresentedBoundsInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }

        var insets = edgeInsets

        if #available(iOS 11.0, *) {
            insets.formUnion(with: containerView.safeAreaInsets)
        }

        return containerView.bounds.inset(by: insets)
    }

    internal func preferredPresentedViewControllerSize(
        in bounds: CGRect
        ) -> CGSize {
        guard let layoutContainer = layoutContainer else { return .zero }

        var fittingSize = bounds.size
        fittingSize.height = 0

        if presentedViewController.hasPreferredContentSize {
            return presentedViewController.preferredContentSize
        }
        else {
            return layoutContainer.systemLayoutSizeFitting(
                fittingSize,
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel)
        }
    }

    internal func layoutDimmingView() {
        guard let containerView = containerView,
            let dimmingView = dimmingView
            else { return }

        containerView.insertSubview(dimmingView, at: 0)

        let views = ["dimmingView": dimmingView]

        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[dimmingView]|",
                views: views),
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[dimmingView]|",
                views: views)
            ])
    }

    internal func layoutLayoutContainer() {
        guard let layoutContainer = layoutContainer,
            let presentedVCView = presentedViewController.view
            else { return }

        layoutContainer.addSubview(presentedVCView)

        let views = ["presentedView": presentedVCView]

        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0@500-[presentedView]|",
                views: views),
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-(>=0)-[presentedView]|",
                views: views),
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[presentedView]|",
                views: views)
            ])
    }

    internal func animateDimmingViewAppearing() {
        guard let dimmingView = dimmingView,
            let transitionCoordinator = presentedViewController
                .transitionCoordinator
            else { return }

        dimmingView.alpha = 0

        transitionCoordinator.animate(alongsideTransition: { _ in
            dimmingView.alpha = 1
        }, completion: nil)
    }

    internal func animateDimmingViewDisappearing() {
        guard let dimmingView = dimmingView,
            let transitionCoordinator = presentedViewController
                .transitionCoordinator
            else { return }

        transitionCoordinator.animate(alongsideTransition: { _ in
            dimmingView.alpha = 0
        }, completion: nil)
    }

    // MARK: - UI Interaction

    @objc internal func userTappedInDimmingArea(
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
