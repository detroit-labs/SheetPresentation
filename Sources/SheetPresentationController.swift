//
//  SheetPresentationController.swift
//  SheetPresentation
//
//  Created by Jeff Kelley on 5/10/19.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import UIKit

// swiftlint:disable:next type_body_length
class SheetPresentationController: UIPresentationController {

    // MARK: - Presentation Options

    let options: SheetPresentationOptions

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
        view.backgroundColor = UIColor.black.withAlphaComponent(alpha)

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
        view.backgroundColor = .clear

        precondition(presentingViewController.view != nil)

        view.passthroughViews = [presentingViewController.view]

        return view
    }()

    // MARK: - UIPresentationController Implementation

    override var frameOfPresentedViewInContainerView: CGRect {
        frameOfPresentedView(in: maximumPresentedBoundsInContainerView)
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        layoutDimmingView()
        layoutPassthroughView()

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

    override var shouldPresentInFullscreen: Bool {
        false
    }

    // MARK: - UIContentContainer Implementation

    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { context in
            let newBounds = context.containerView.bounds
                .inset(by: self.marginAdjustedEdgeInsets(for: context))

            self.presentedView?.frame = self.frameOfPresentedView(in: newBounds)
        })
    }

    override func willTransition(
        to newCollection: UITraitCollection,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.willTransition(to: newCollection, with: coordinator)

        coordinator.animate(alongsideTransition: { context in
            let newBounds = context.containerView.bounds
                .inset(by: self.marginAdjustedEdgeInsets(for: context))

            self.presentedView?.frame = self.frameOfPresentedView(in: newBounds)
        })
    }

    override func size(forChildContentContainer container: UIContentContainer,
                       withParentContainerSize parentSize: CGSize) -> CGSize {
        // Ensure that the view is loaded, in case the preferred content size is
        // set during loadView() or viewDidLoad()
        presentedViewController.loadViewIfNeeded()

        if presentedViewController.hasPreferredContentSize {
            return presentedViewController.preferredContentSize
        }

        if options.presentationLayout.horizontalLayout == .fill,
            options.presentationLayout.verticalLayout == .fill {
            return parentSize
        }

        var targetSize: CGSize = UIView.layoutFittingCompressedSize
        var horizontalPriority: UILayoutPriority
        var verticalPriority: UILayoutPriority

        switch options.presentationLayout.horizontalLayout {
        case .fill:
            targetSize.width = parentSize.width
            horizontalPriority = .required
        case .automatic:
            horizontalPriority = .defaultLow
        }

        switch options.presentationLayout.verticalLayout {
        case .fill:
            targetSize.height = parentSize.height
            verticalPriority = .required
        case .automatic:
            verticalPriority = .defaultLow
        }

        var computedSize = presentedViewController.view.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: horizontalPriority,
            verticalFittingPriority: verticalPriority
        )

        if computedSize.width > parentSize.width {
            targetSize.width = parentSize.width
            horizontalPriority = .required

            computedSize = presentedViewController.view.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: horizontalPriority,
                verticalFittingPriority: verticalPriority
            )
        }

        if computedSize.height > parentSize.height {
            targetSize.height = parentSize.height
            verticalPriority = .required

            computedSize = presentedViewController.view.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: horizontalPriority,
                verticalFittingPriority: verticalPriority
            )
        }

        return computedSize
    }

    override func preferredContentSizeDidChange(
        forChildContentContainer container: UIContentContainer
    ) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)

        if container as? UIViewController == presentedViewController {
            layoutPresentedViewController()
        }
    }

    override func systemLayoutFittingSizeDidChange(
        forChildContentContainer container: UIContentContainer
    ) {
        super.systemLayoutFittingSizeDidChange(
            forChildContentContainer: container
        )

        if container as? UIViewController == presentedViewController {
            layoutPresentedViewController()
        }
    }

    // MARK: - Internal Implementation

    func marginAdjustedEdgeInsets(
        for context: UIViewControllerTransitionCoordinatorContext
    ) -> UIEdgeInsets {
        let margins: UIEdgeInsets

        if let containerView = containerView {
            margins = containerView.layoutMargins
        }
        else if let presentedView = context.view(forKey: .to) {
            if #available(iOS 11.0, macCatalyst 10.15, *) {
                margins = presentedView.safeAreaInsets
            } else {
                margins = presentedView.layoutMargins
            }
        }
        else {
            margins = .zero
        }

        return marginAdjustedEdgeInsets(for: margins)
    }

    func marginAdjustedEdgeInsets(for margins: UIEdgeInsets) -> UIEdgeInsets {
        var insets = options.edgeInsets.fixedEdgeInsets(for: traitCollection)

        let ignoredEdgesForMargins = options.ignoredEdgesForMargins.map {
            $0.fixedViewEdge(using: traitCollection)
        }

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

    func frameOfPresentedView(in bounds: CGRect) -> CGRect {
        var size = self.size(forChildContentContainer: presentedViewController,
                             withParentContainerSize: bounds.size)

        // If the preferred size extends beyond the maximum bounds (for
        // instance, if set by the preferredContentSize of the view controller),
        // clamp them to the maximum bounds.
        size.height = min(size.height, bounds.height)
        size.width = min(size.width, bounds.width)

        var frame = CGRect(origin: .zero, size: size)

        let isRightToLeft = (traitCollection.layoutDirection == .rightToLeft)

        switch options.presentationLayout.horizontalLayout {
        case .automatic(alignment: .leading) where !isRightToLeft,
             .automatic(alignment: .left),
             .automatic(alignment: .trailing) where isRightToLeft,
             .fill:
            frame.origin.x = bounds.minX

        case .automatic(alignment: .center):
            frame.origin.x = bounds.minX + ((bounds.width - size.width) / 2)

        case .automatic(alignment: .leading),
             .automatic(alignment: .right),
             .automatic(alignment: .trailing):
            frame.origin.x = bounds.maxX - size.width
        }

        switch options.presentationLayout.verticalLayout {
        case .automatic(alignment: .top),
             .fill:
            frame.origin.y = bounds.minY

        case .automatic(alignment: .middle):
            frame.origin.y = bounds.minY +
                ((bounds.height - size.height) / 2)

        case .automatic(alignment: .bottom):
            frame.origin.y = bounds.maxY - size.height
        }

        return frame.integral
    }

    var maximumPresentedBoundsInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }

        return containerView.bounds
            .inset(by: marginAdjustedEdgeInsets(
                for: containerView.layoutMargins
            ))
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

    private func layoutPresentedViewController() {
        guard containerView != nil,
            let view = presentedViewController.viewIfLoaded
            else { return }

        let newFrame = frameOfPresentedViewInContainerView

        if view.frame != newFrame {
            view.frame = newFrame
        }
    }

    func animateDimmingViewAppearing() {
        guard let dimmingView = dimmingView,
            let transitionCoordinator = presentedViewController
                .transitionCoordinator
            else { return }

        dimmingView.alpha = 0

        transitionCoordinator.animate(
            id: "animateDimmingViewAppearing",
            alongsideTransition: { _ in dimmingView.alpha = 1 }
        )
    }

    func animateDimmingViewDisappearing() {
        guard let dimmingView = dimmingView,
            let transitionCoordinator = presentedViewController
                .transitionCoordinator
            else { return }

        transitionCoordinator.animate(
            id: "animateDimmingViewDisappearing",
            alongsideTransition: { _ in dimmingView.alpha = 0 },
            completion: { _ in dimmingView.removeFromSuperview() }
        )
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
