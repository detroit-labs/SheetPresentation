//
//  BottomSheetPresentationController.swift
//  BottomSheetPresentation
//
//  Created by Jeff Kelley on 5/10/19.
//  Copyright © 2019 Detroit Labs. All rights reserved.
//

import UIKit

#if SWIFT_PACKAGE
import BottomSheetPresentationLegacySupport
#endif

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

    internal var maskedCorners: CACornerMask {
        didSet {
            if let layoutContainer = layoutContainer {
                if #available(iOS 11.0, *) {
                    layoutContainer.layer.maskedCorners = maskedCorners
                }
            }
        }
    }

    internal var dimmingViewAlpha: CGFloat? {
        didSet {
            if let alpha = dimmingViewAlpha, let dimmingView = dimmingView {
                dimmingView.backgroundColor = dimmingView.backgroundColor?
                    .withAlphaComponent(alpha)
            }
            else if dimmingViewAlpha == nil {
                dimmingView?.removeFromSuperview()
                dimmingView = nil
            }
        }
    }

    internal var edgeInsets: UIEdgeInsets {
        didSet {
            (containerView ?? presentedView)?.setNeedsLayout()
        }
    }

    internal var ignoredEdgesForMargins: ViewEdge

    internal var marginAdjustedEdgeInsets: UIEdgeInsets {
        var insets = edgeInsets

        if let containerView = containerView {
            if !ignoredEdgesForMargins.contains(.top) {
                insets.top = max(insets.top, containerView.layoutMargins.top)
            }
            if !ignoredEdgesForMargins.contains(.left) {
                insets.left = max(insets.left,
                                  containerView.layoutMargins.left)
            }
            if !ignoredEdgesForMargins.contains(.right) {
                insets.right = max(insets.right,
                                   containerView.layoutMargins.right)
            }
            if !ignoredEdgesForMargins.contains(.bottom) {
                insets.bottom = max(insets.bottom,
                                    containerView.layoutMargins.bottom)
            }
        }

        return insets
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
        maskedCorners = options.maskedCorners
        dimmingViewAlpha = options.dimmingViewAlpha
        edgeInsets = options.edgeInsets
        ignoredEdgesForMargins = options.ignoredEdgesForMargins
        self.dimmingViewTapHandler = dimmingViewTapHandler

        super.init(presentedViewController: presented, presenting: presenting)
    }

    // MARK: - Private Subviews

    internal lazy var dimmingView: UIView? = {
        guard let alpha = dimmingViewAlpha else { return nil }

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
            .withAlphaComponent(alpha)

        view.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(userTappedInDimmingArea(_:))))

        return view
    }()

    internal lazy var passthroughView: PassthroughView? = {
        guard dimmingViewAlpha == nil else { return nil }

        let view = PassthroughView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear

        view.passthroughViews = [presentingViewController.view]

        return view
    }()

    internal lazy var layoutContainer: UIView? = {
        let view = UIView()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.layer.cornerRadius = cornerRadius
        if #available(iOS 11.0, *) {
            view.layer.maskedCorners = maskedCorners
        }
        view.clipsToBounds = true
        return view
    }()

    // MARK: - Public UIPresentationController Implementation

    /// The view to be animated by the animator objects during a transition.
    override public var presentedView: UIView? { return layoutContainer }

    /// The frame rectangle to assign to the presented view at the end of the
    /// animations.
    override public var frameOfPresentedViewInContainerView: CGRect {
        let maximumBounds = maximumPresentedBoundsInContainerView

        var size = preferredPresentedViewControllerSize(in: maximumBounds)

        // Constrain the width and height to the safe area of the container view
        size.height = min(size.height, maximumBounds.height)
        size.width = min(size.width, maximumBounds.width)

        var frame = maximumBounds

        // Position the rect vertically at the bottom of the maximum bounds
        frame.origin.y = maximumBounds.maxY - size.height
        frame.size.height = size.height

        // Center the rect horizontally inside the maximum bounds
        frame.origin.x = maximumBounds.minX +
            ((maximumBounds.width - size.width) / 2.0)

        frame.size.width = size.width

        return frame.integral
    }

    /// Notifies the presentation controller that layout is about to begin on
    /// the views of the container view.
    override public func containerViewWillLayoutSubviews() {
        guard let containerView = containerView else { return }
        dimmingView?.frame = containerView.bounds
        passthroughView?.frame = containerView.bounds
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    /// Notifies the presentation controller that the presentation animations
    /// are about to start.
    override public func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        layoutDimmingView()
        layoutPassthroughView()
        layoutPresentedViewController()

        animateDimmingViewAppearing()
    }

    /// Notifies the presentation controller that the dismissal animations are
    /// about to start.
    override public func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        animateDimmingViewDisappearing()
    }

    /// A Boolean value indicating whether the presentation covers the entire
    /// screen.
    public override var shouldPresentInFullscreen: Bool {
        return false
    }

    // MARK: - Private Implementation

    internal var maximumPresentedBoundsInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }

        let insets = marginAdjustedEdgeInsets

        #if swift(>=4.2)
        return containerView.bounds.inset(by: insets)
        #else
        return UIEdgeInsetsInsetRect(containerView.bounds, insets)
        #endif
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
        guard
            let containerView = containerView,
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

    internal func layoutPassthroughView() {
        guard
            let containerView = containerView,
            let passthroughView = passthroughView
            else { return }

        containerView.insertSubview(passthroughView, at: 0)

        let views = ["passthroughView": passthroughView]

        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[passthroughView]|",
                views: views),
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[passthroughView]|",
                views: views)
            ])
    }

    internal func layoutPresentedViewController() {
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
