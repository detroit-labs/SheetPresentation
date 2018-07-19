//
//  BottomSheetPresentation.swift
//  SheetPresentation
//
//  Created by Jeff Kelley on 7/17/18.
//  Copyright © 2018 Jeff Kelley. All rights reserved.
//

import UIKit

/// A manager object that creates instances of `BottomSheetPresentationController`
/// when set as a view controller’s `transitioningDelegate`.
public final class BottomSheetPresentationManager: NSObject {}

extension BottomSheetPresentationManager: UIViewControllerTransitioningDelegate {

    public func presentationController(forPresented presented: UIViewController,
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {
        let controller = BottomSheetPresentationController(
            presentedViewController: presented,
            presenting: presenting)

        controller.delegate = self

        return controller
    }

}

extension BottomSheetPresentationManager: UIAdaptivePresentationControllerDelegate {

    public func adaptivePresentationStyle(for controller: UIPresentationController,
                                          traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .overCurrentContext
    }

}

/// A presentation controller for presenting a view controller over the bottom
/// portion of the screen, automatically growing the view controller as needed based
/// on either its `preferredContentSize` or Auto Layout.
public final class BottomSheetPresentationController: UIPresentationController {

    // MARK: - Configuration Properties

    /// The corner radius to use when displaying the presented view controller.
    /// Defaults to `10`.
    public var cornerRadius: CGFloat = 10 {
        didSet { layoutContainer?.layer.cornerRadius = cornerRadius }
    }

    /// The `alpha` value for the dimming view used behind the presented view
    /// controller. The color is black. Defaults to `0.25`.
    public var dimmingViewAlpha: CGFloat = 0.25 {
        didSet {
            if let dimmingView = dimmingView {
                dimmingView.backgroundColor = dimmingView.backgroundColor?
                    .withAlphaComponent(dimmingViewAlpha)
            }
        }
    }

    /// The amount to inset the presented view controller from the presenting view
    /// controller. This is a minimum; there may be additional insets depending on
    /// the safe area insets of the presenting view controller’s view. Defaults to
    /// 20 points on each side.
    public var edgeInsets = UIEdgeInsets(constant: 20) {
        didSet {
            containerView?.setNeedsLayout()
        }
    }

    // MARK: - Private Subviews

    private lazy var dimmingView: UIView? = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(dimmingViewAlpha)

        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self,
                                   action: #selector(userTappedInDimmingArea(_:))))

        return view
    }()

    private lazy var layoutContainer: UIView? = {
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

        // Position the rect at the bottom of the maximum bounds
        var frame = maximumBounds
            .divided(atDistance: size.height, from: .maxYEdge)
            .slice

        // Center the rect inside the maxium bounds
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

    // MARK: - Private Implementation

    private var maximumPresentedBoundsInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }

        if #available(iOS 11.0, *) {
            return containerView.bounds
                .inset(by: edgeInsets.union(with: containerView.safeAreaInsets))
        } else {
            return containerView.bounds
        }
    }

    private func preferredPresentedViewControllerSize(in bounds: CGRect) -> CGSize {
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

    private func layoutDimmingView() {
        guard let containerView = containerView,
            let dimmingView = dimmingView
            else { return }

        containerView.insertSubview(dimmingView, at: 0)

        NSLayoutConstraint.activate([
            dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }

    private func layoutLayoutContainer() {
        guard let layoutContainer = layoutContainer,
            let presentedVCView = presentedViewController.view
            else { return }

        layoutContainer.addSubview(presentedVCView)

        let views = [ "presentedView": presentedVCView ]

        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-0@500-[presentedView]|",
                                           options: [],
                                           metrics: nil,
                                           views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=0)-[presentedView]|",
                                           options: [],
                                           metrics: nil,
                                           views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[presentedView]|",
                                           options: [],
                                           metrics: nil,
                                           views: views),
            ].flatMap{ $0 })
    }

    private func animateDimmingViewAppearing() {
        guard let dimmingView = dimmingView,
            let tc = presentedViewController.transitionCoordinator
            else { return }

        dimmingView.alpha = 0

        tc.animate(alongsideTransition: { _ in dimmingView.alpha = 1 },
                   completion: nil)
    }

    private func animateDimmingViewDisappearing() {
        guard let dimmingView = dimmingView,
            let tc = presentedViewController.transitionCoordinator
            else { return }

        tc.animate(alongsideTransition: { _ in dimmingView.alpha = 0 },
                   completion: nil)
    }

    // MARK: - UI Interaction

    @objc private func userTappedInDimmingArea(_ gestureRecognizer: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }

}

extension UIViewController {

    /// Returns `true` if the `width` and `height` of the view controller’s
    /// `preferredContentSize` are both larger than `0`.
    var hasPreferredContentSize: Bool {
        return preferredContentSize.width > 0 && preferredContentSize.height > 0
    }

}

extension UIEdgeInsets {

    /// Initializes a `UIEdgeInsets` with a constant value for `top`, `left`,
    /// `bottom`, and `right`.
    ///
    /// - Parameter constant: The constant value to use for all four dimensions.
    public init(constant: CGFloat) {
        self.init(top: constant, left: constant, bottom: constant, right: constant)
    }

    /// Forms a union with the given edge insets. Each value in the insets will be
    /// the larger of the two values.
    ///
    /// - Parameter otherInsets: The other insets with which to form a union.
    /// - Returns: A `UIEdgeInsets` object that will inset a rect to accomodate both
    ///            given edge insets.
    public func union(with otherInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: max(top, otherInsets.top),
                            left: max(left, otherInsets.left),
                            bottom: max(bottom, otherInsets.bottom),
                            right:  max(right, otherInsets.right))
    }

}
