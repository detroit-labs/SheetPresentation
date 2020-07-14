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

        // TODO: Translate from leading/trailing to left/right

        if !ignoredEdgesForMargins.contains(.top) {
            insets.top = max(insets.top, margins.top)
        }
        if !ignoredEdgesForMargins.contains(.leading) {
            insets.left = max(insets.left, margins.left)
        }
        if !ignoredEdgesForMargins.contains(.trailing) {
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

        // If the preferred size extends beyone the maxiumum bounds (for
        // instance, if set by the preferredContentSize of the view controller),
        // clamp them to the maximum bounds.
        size.height = min(size.height, maximumBounds.height)
        size.width = min(size.width, maximumBounds.width)

        var frame = CGRect(origin: maximumBounds.origin, size: size)

        // TODO: Account for left/right/leading/trailing

        switch options.presentationLayout {

        case .top(.automatic(let alignment)) where alignment == .middle,
             .bottom(.automatic(let alignment)) where alignment == .middle:
            frame.origin.y = (maximumBounds.height - frame.height) / 2

        case .top(.automatic(let alignment)) where alignment == .bottom,
             .bottom(.automatic(let alignment)) where alignment == .bottom:
            frame.origin.y = maximumBounds.height - frame.height

        case .leading(.automatic(let alignment)) where alignment == .center,
             .trailing(.automatic(let alignment)) where alignment == .center:
            frame.origin.x = (maximumBounds.width - frame.width) / 2

        case .leading(.automatic(let alignment)) where alignment == .trailing,
             .trailing(.automatic(let alignment)) where alignment == .trailing:
            frame.origin.x = maximumBounds.width - frame.width

        default:
            break

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

    // swiftlint:disable:next function_body_length
    func preferredPresentedViewControllerSize(fitting size: CGSize) -> CGSize {
        // Ensure that the view is loaded, in case the preferred content size is
        // set during loadView() or viewDidLoad()
        presentedViewController.loadViewIfNeeded()

        var targetSize: CGSize = UIView.layoutFittingCompressedSize
        let horizontalPriority: UILayoutPriority
        let verticalPriority: UILayoutPriority

        let preferredContentSize = presentedViewController.preferredContentSize
        let hasPreferredContentSize = presentedViewController
            .hasPreferredContentSize

        switch options.presentationLayout {

        // “Fill” layouts just fill the container entirely. These are still
        // useful as they control the animation origin.
        case .top(.fill),
             .leading(.fill),
             .trailing(.fill),
             .bottom(.fill),
             .overlay(.fill, .fill):
            return size

        // “Automatic” layouts use the preferred content size of the view
        // controller, if specified.
        case .top(.automatic) where hasPreferredContentSize,
             .bottom(.automatic) where hasPreferredContentSize,
             .leading(.automatic) where hasPreferredContentSize,
             .trailing(.automatic) where hasPreferredContentSize,
             .overlay(.automatic, .automatic) where hasPreferredContentSize:
            return presentedViewController.preferredContentSize

        // Top and bottom layouts fill the width of the container.
        case .top(.automatic), .bottom(.automatic):
            targetSize.width = size.width
            horizontalPriority = .required
            verticalPriority = .fittingSizeLevel

        // Leading and trailing layouts fill the height of the container.
        case .leading(.automatic), .trailing(.automatic):
            targetSize.height = size.height
            horizontalPriority = .fittingSizeLevel
            verticalPriority = .fittingSizeLevel

        // Overlay layouts fill according to their behaviors
        case .overlay(.automatic, .fill) where hasPreferredContentSize:
            targetSize.width = preferredContentSize.width
            return targetSize

        case .overlay(.automatic, .fill):
            targetSize.height = size.height
            horizontalPriority = .fittingSizeLevel
            verticalPriority = .fittingSizeLevel

        case .overlay(.fill, .automatic) where hasPreferredContentSize:
            targetSize.height = preferredContentSize.height
            return targetSize

        case .overlay(.fill, .automatic):
            targetSize.width = size.width
            horizontalPriority = .required
            verticalPriority = .fittingSizeLevel

        case .overlay(.automatic, .automatic):
            horizontalPriority = .fittingSizeLevel
            verticalPriority = .fittingSizeLevel
        }

        return presentedViewController.view.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: horizontalPriority,
            verticalFittingPriority: verticalPriority
        )
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
