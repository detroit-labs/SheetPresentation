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
        var insets = options.edgeInsets.fixedEdgeInsets(for: traitCollection)
        let margins: UIEdgeInsets

        if #available(iOS 12, *), let containerView = containerView {
            margins = containerView.layoutMargins
        }
        else {
            margins = presentingViewController.view.safeAreaInsets
        }

        let ignoredEdgesForMargins = options.ignoredEdgesForMargins

        let isRightToLeft = (traitCollection.layoutDirection == .rightToLeft)

        if !ignoredEdgesForMargins.contains(.top) {
            insets.top = max(insets.top, margins.top)
        }
        if !ignoredEdgesForMargins.contains(.leading) {
            if isRightToLeft {
                insets.right = max(insets.right, margins.right)
            }
            else {
                insets.left = max(insets.left, margins.left)
            }
        }
        if !ignoredEdgesForMargins.contains(.trailing) {
            if isRightToLeft {
                insets.left = max(insets.left, margins.left)
            }
            else {
                insets.right = max(insets.right, margins.right)
            }
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

        let isRightToLeft = (traitCollection.layoutDirection == .rightToLeft)

        switch options.presentationLayout {

        case .leading(.fill),
             .trailing(.fill),
             .top(.fill),
             .bottom(.fill),
             .overlay(.fill, .fill),
             .left(.fill),
             .right(.fill):
            return frame

        case .leading(.automatic(alignment: .leading)) where !isRightToLeft,
             .leading(.automatic(alignment: .trailing)) where isRightToLeft,
             .leading(.automatic(alignment: .left)),
             .trailing(.automatic(alignment: .leading)) where !isRightToLeft,
             .trailing(.automatic(alignment: .trailing)) where isRightToLeft,
             .trailing(.automatic(alignment: .left)),
             .top(.automatic(alignment: .top)),
             .bottom(.automatic(alignment: .top)),
             .left(.automatic(alignment: .leading)) where !isRightToLeft,
             .left(.automatic(alignment: .trailing)) where isRightToLeft,
             .left(.automatic(alignment: .left)),
             .right(.automatic(alignment: .leading)) where !isRightToLeft,
             .right(.automatic(alignment: .trailing)) where isRightToLeft,
             .right(.automatic(alignment: .left)),
             .overlay(.automatic(alignment: .leading),
                      .automatic(alignment: .top)) where !isRightToLeft,
             .overlay(.automatic(alignment: .trailing),
                      .automatic(alignment: .top)) where isRightToLeft,
             .overlay(.automatic(alignment: .left),
                      .automatic(alignment: .top)),
             .overlay(.automatic(alignment: .leading),
                      .fill) where !isRightToLeft,
             .overlay(.automatic(alignment: .trailing),
                      .fill) where isRightToLeft,
             .overlay(.automatic(alignment: .left), .fill),
             .overlay(.fill, .automatic(alignment: .top)):
            // Do nothing; the frame starts at the top-left point.
            return frame

        case .leading(.automatic(alignment: .center)),
             .trailing(.automatic(alignment: .center)),
             .left(.automatic(alignment: .center)),
             .right(.automatic(alignment: .center)),
             .overlay(.automatic(alignment: .center), .fill),
             .overlay(.automatic(alignment: .center),
                      .automatic(alignment: .top)):
            // Align the frame in the center of the bounds horizontally.
            frame.origin.x = maximumBounds.minX +
                ((maximumBounds.width - frame.width) / 2)

        case .leading(.automatic(alignment: .leading)),
             .leading(.automatic(alignment: .trailing)),
             .leading(.automatic(alignment: .right)),
             .trailing(.automatic(alignment: .leading)),
             .trailing(.automatic(alignment: .trailing)),
             .trailing(.automatic(alignment: .right)),
             .left(.automatic(alignment: .leading)),
             .left(.automatic(alignment: .trailing)),
             .left(.automatic(alignment: .right)),
             .right(.automatic(alignment: .leading)),
             .right(.automatic(alignment: .trailing)),
             .right(.automatic(alignment: .right)),
             .overlay(.automatic(alignment: .leading), .fill),
             .overlay(.automatic(alignment: .trailing), .fill),
             .overlay(.automatic(alignment: .right), .fill),
             .overlay(.automatic(alignment: .leading),
                      .automatic(alignment: .top)),
             .overlay(.automatic(alignment: .trailing),
                      .automatic(alignment: .top)),
             .overlay(.automatic(alignment: .right),
                      .automatic(alignment: .top)):
            // Align the frame at the right of the bounds.
            frame.origin.x = maximumBounds.maxX - frame.width

        case .top(.automatic(alignment: .middle)),
             .bottom(.automatic(alignment: .middle)),
             .overlay(.fill, .automatic(alignment: .middle)),
             .overlay(.automatic(alignment: .leading),
                      .automatic(alignment: .middle)) where !isRightToLeft,
             .overlay(.automatic(alignment: .trailing),
                      .automatic(alignment: .middle)) where isRightToLeft,
             .overlay(.automatic(.left), .automatic(alignment: .middle)):
            // Align the frame in the middle of the bounds vertically.
            frame.origin.y = maximumBounds.minY +
                ((maximumBounds.height - frame.height) / 2)

        case .top(.automatic(alignment: .bottom)),
             .bottom(.automatic(alignment: .bottom)),
             .overlay(.fill, .automatic(alignment: .bottom)),
             .overlay(.automatic(alignment: .leading),
                      .automatic(alignment: .bottom)) where !isRightToLeft,
             .overlay(.automatic(alignment: .trailing),
                      .automatic(alignment: .bottom)) where isRightToLeft,
             .overlay(.automatic(alignment: .left),
                      .automatic(alignment: .bottom)):
            // Align the frame at the bottom of the bounds.
            frame.origin.y = maximumBounds.maxY - frame.height

        case .overlay(.automatic(alignment: .center),
                      .automatic(alignment: .middle)):
            // Align the frame at the center of the bounds horizontally and
            // middle of the bounds vertically.
            frame.origin.x = maximumBounds.minX +
                ((maximumBounds.width - frame.width) / 2)

            frame.origin.y = maximumBounds.minY +
                ((maximumBounds.height - frame.height) / 2)

        case .overlay(.automatic(alignment: .leading),
                      .automatic(alignment: .middle)),
             .overlay(.automatic(alignment: .trailing),
                      .automatic(alignment: .middle)),
             .overlay(.automatic(alignment: .right),
                      .automatic(alignment: .middle)):
            // Align the frame at the right of the bounds horizontally and
            // middle of the bounds vertically.
            frame.origin.x = maximumBounds.maxX - frame.width

            frame.origin.y = maximumBounds.minY +
                ((maximumBounds.height - frame.height) / 2)

        case .overlay(.automatic(alignment: .center),
                      .automatic(alignment: .bottom)):
            // Align the frame at the center of the bounds horizontally and
            // bottom of the bounds vertically.
            frame.origin.x = maximumBounds.minX +
                ((maximumBounds.width - frame.width) / 2)

            frame.origin.y = maximumBounds.maxY - frame.height

        case .overlay(.automatic(alignment: .leading),
                      .automatic(alignment: .bottom)),
             .overlay(.automatic(alignment: .trailing),
                      .automatic(alignment: .bottom)),
             .overlay(.automatic(alignment: .right),
                      .automatic(alignment: .bottom)):
            // Align the frame at the right of the bounds horizontally and
            // bottom of the bounds vertically.
            frame.origin.x = maximumBounds.maxX - frame.width
            frame.origin.y = maximumBounds.maxY - frame.height

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
             .left(.fill),
             .trailing(.fill),
             .right(.fill),
             .bottom(.fill),
             .overlay(.fill, .fill):
            return size

        // “Automatic” layouts use the preferred content size of the view
        // controller, if specified.
        case .top(.automatic) where hasPreferredContentSize,
             .bottom(.automatic) where hasPreferredContentSize,
             .leading(.automatic) where hasPreferredContentSize,
             .left(.automatic) where hasPreferredContentSize,
             .trailing(.automatic) where hasPreferredContentSize,
             .right(.automatic) where hasPreferredContentSize,
             .overlay(.automatic, .automatic) where hasPreferredContentSize:
            return presentedViewController.preferredContentSize

        // Vertical layouts fill the width of the container.
        case .top(.automatic), .bottom(.automatic):
            targetSize.width = size.width
            horizontalPriority = .required
            verticalPriority = .fittingSizeLevel

        // Horizontal layouts fill the height of the container.
        case .leading(.automatic),
             .left(.automatic),
             .trailing(.automatic),
             .right(.automatic):
            targetSize.height = size.height
            horizontalPriority = .fittingSizeLevel
            verticalPriority = .required

        // Overlay layouts fill according to their behaviors
        case .overlay(.automatic, .fill) where hasPreferredContentSize:
            targetSize.width = preferredContentSize.width
            targetSize.height = size.height
            return targetSize

        case .overlay(.automatic, .fill):
            targetSize.height = size.height
            horizontalPriority = .fittingSizeLevel
            verticalPriority = .required

        case .overlay(.fill, .automatic) where hasPreferredContentSize:
            targetSize.height = preferredContentSize.height
            targetSize.width = size.width
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
