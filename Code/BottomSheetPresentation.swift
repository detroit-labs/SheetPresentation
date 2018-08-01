//
//  BottomSheetPresentation.swift
//  SheetPresentation
//
//  Created by Jeff Kelley on 7/17/18.
//  Copyright © 2018 Detroit Labs, LLC. All rights reserved.
//

import UIKit

// The direction which the sheet will be presented from.
public enum PresentationDirection {
    case left, right, bottom
}

/// Options for presentation. These options are passed to created
/// `BottomSheetPresentationController` objects upon creation.
public struct BottomSheetPresentationOptions {

    /// The corner radius to use when displaying the presented view controller.
    public let cornerRadius: CGFloat

    /// The `alpha` value for the dimming view used behind the presented
    /// view controller. The color is black.
    public let dimmingViewAlpha: CGFloat

    /// The amount to inset the presented view controller from the
    /// presenting view controller. This is a minimum; there may be
    /// additional insets depending on the safe area insets of the
    /// presenting view controller’s view.
    public let edgeInsets: UIEdgeInsets

    // Direction view controller will be presented from
    public let direction: PresentationDirection

    /// The default options that are used when calling `init()` on a
    /// `BottomSheetPresentationManager` with no options.
    public static let defaultOptions = BottomSheetPresentationOptions(
        cornerRadius: 10,
        dimmingViewAlpha: 0.5,
        edgeInsets: UIEdgeInsets(constant: 20),
        direction: .bottom)

    /// Creates a new `BottomSheetPresentationOptions` struct.
    ///
    /// - Parameters:
    ///   - cornerRadius: The corner radius to use when displaying the presented
    ///                   view controller. Defaults to `10`.
    ///   - dimmingViewAlpha: The `alpha` value for the dimming view used behind
    ///                       the presented view controller. The color is black.
    ///                       Defaults to `0.5`.
    ///   - edgeInsets: The amount to inset the presented view controller from
    ///                 the presenting view controller. This is a minimum; there
    ///                 may be additional insets depending on the safe area
    ///                 insets of the presenting view controller’s view (iOS 11
    ///                 and later). Defaults to edge insets of `20` points on
    ///                 each side.
    ///   - direction: The direction the view controller will be presented from.
    ///                Defaults to 'PresentationDirection.bottom'.
    public init(cornerRadius: CGFloat = 10,
                dimmingViewAlpha: CGFloat = 0.5,
                edgeInsets: UIEdgeInsets = UIEdgeInsets(constant: 20),
                direction: PresentationDirection = .bottom) {
        self.cornerRadius = cornerRadius
        self.dimmingViewAlpha = dimmingViewAlpha
        self.edgeInsets = edgeInsets
        self.direction = direction
    }
}

extension BottomSheetPresentationOptions: Equatable {}

/// An object that creates instances of `BottomSheetPresentationController` when
/// set as a view controller’s `transitioningDelegate`.
@objcMembers public final class BottomSheetPresentationManager: NSObject {

    internal let presentationOptions: BottomSheetPresentationOptions

    /// Creates a `BottomSheetPresentationManager` with specific presentation
    /// options.
    ///
    /// - Parameter options: The options to use for presenting view controllers.
    public init(options: BottomSheetPresentationOptions = .defaultOptions) {
        presentationOptions = options
    }

    /// Creates a `BottomSheetPresentationManager` with specific presentation
    /// options.
    ///
    /// - Parameters:
    ///     - cornerRadius: The corner radius to use when displaying the
    ///                     presented view controller.
    ///     - dimmingViewAlpha: The `alpha` value for the dimming view used
    ///                         behind the presented view controller. The color
    ///                         is black.
    ///     - edgeInsets: The amount to inset the presented view controller from
    ///                   the presenting view controller. This is a minimum;
    ///                   there may be additional insets depending on the safe
    ///                   area insets of the presenting view controller’s view.
    ///     - direction: The direction the view controller will be presented from.
    public convenience init(cornerRadius: CGFloat,
                            dimmingViewAlpha: CGFloat,
                            edgeInsets: UIEdgeInsets,
                            direction: PresentationDirection) {
        let options = BottomSheetPresentationOptions(
            cornerRadius: cornerRadius,
            dimmingViewAlpha: dimmingViewAlpha,
            edgeInsets: edgeInsets,
            direction: direction)

        self.init(options: options)
    }

}

extension BottomSheetPresentationManager: UIViewControllerTransitioningDelegate {

    public func presentationController(forPresented presented: UIViewController,
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {
        let controller = BottomSheetPresentationController(
            forPresented: presented,
            presenting: presenting,
            presentationOptions: presentationOptions)

        controller.delegate = self

        return controller
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch presentationOptions.direction {
        case .bottom:
            return nil
        default:
            return SheetPresentationAnimator(direction: presentationOptions.direction, isPresentation: true)
        }
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch presentationOptions.direction {
        case .bottom:
            return nil
        default:
            return SheetPresentationAnimator(direction: presentationOptions.direction, isPresentation: false)
        }
    }

}

extension BottomSheetPresentationManager: UIAdaptivePresentationControllerDelegate {

    public func adaptivePresentationStyle(for controller: UIPresentationController,
                                          traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .overCurrentContext
    }

    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .overCurrentContext
    }

}

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
            containerView?.setNeedsLayout()
        }
    }

    internal var direction: PresentationDirection

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
    public init(forPresented presented: UIViewController,
                presenting: UIViewController?,
                presentationOptions options: BottomSheetPresentationOptions = .defaultOptions) {
        cornerRadius = options.cornerRadius
        dimmingViewAlpha = options.dimmingViewAlpha
        edgeInsets = options.edgeInsets
        direction = options.direction

        super.init(presentedViewController: presented, presenting: presenting)
    }

    // MARK: - Private Subviews

    internal lazy var dimmingView: UIView? = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(dimmingViewAlpha)

        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self,
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
        var frame = maximumBounds

        switch direction {
        case .bottom:
            // Constrain the width and height to the safe area of the container view
            size.height = min(size.height, maximumBounds.height)
            size.width = min(size.width, maximumBounds.width)

            // Position the rect vertically at the bottom of the maximum bounds
            frame.origin.y = maximumBounds.maxY - size.height
            frame.size.height = size.height

            // Center the rect horizontally inside the container bounds
            frame.origin.x = (containerView.bounds.width - size.width) / 2.0
            frame.size.width = size.width

        case .right:
            frame.origin.x = containerView.bounds.width * (0.68 / 3.0)
            frame.size = CGSize(width: maximumBounds.width * (2.32 / 3.0), height: maximumBounds.height)

        case .left:
            frame.origin.x = 0
            frame.size = CGSize(width: maximumBounds.width * (2.32 / 3.0), height: maximumBounds.height)
        }

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

    internal func preferredPresentedViewControllerSize(in bounds: CGRect) -> CGSize {
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
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|",
                                           views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|",
                                           views: views),
            ])
    }

    internal func layoutLayoutContainer() {
        guard let layoutContainer = layoutContainer,
            let presentedVCView = presentedViewController.view
            else { return }

        layoutContainer.addSubview(presentedVCView)

        let views = ["presentedView": presentedVCView]

        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-0@500-[presentedView]|",
                                           views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=0)-[presentedView]|",
                                           views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[presentedView]|",
                                           views: views),
            ])
    }

    internal func animateDimmingViewAppearing() {
        guard let dimmingView = dimmingView,
            let tc = presentedViewController.transitionCoordinator
            else { return }

        dimmingView.alpha = 0

        tc.animate(alongsideTransition: { _ in dimmingView.alpha = 1 },
                   completion: nil)
    }

    internal func animateDimmingViewDisappearing() {
        guard let dimmingView = dimmingView,
            let tc = presentedViewController.transitionCoordinator
            else { return }

        tc.animate(alongsideTransition: { _ in dimmingView.alpha = 0 },
                   completion: nil)
    }

    // MARK: - UI Interaction

    @objc internal func userTappedInDimmingArea(_ gestureRecognizer: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }

}

public final class SheetPresentationAnimator: NSObject {

    let direction: PresentationDirection
    let isPresentation: Bool

    init(direction: PresentationDirection, isPresentation: Bool) {
        self.direction = direction
        self.isPresentation = isPresentation
        super.init()
    }
}

extension SheetPresentationAnimator: UIViewControllerAnimatedTransitioning {

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let key = isPresentation ? UITransitionContextViewControllerKey.to : UITransitionContextViewControllerKey.from
        let controller = transitionContext.viewController(forKey: key)!

        if isPresentation {
            transitionContext.containerView.addSubview(controller.view)
        }

        let presentedFrame = transitionContext.finalFrame(for: controller)
        var dismissedFrame = presentedFrame

        switch direction {
        case .left:
            dismissedFrame.origin.x = -presentedFrame.width
        case .right:
            dismissedFrame.origin.x = transitionContext.containerView.frame.size.width
        case .bottom:
            dismissedFrame.origin.y = transitionContext.containerView.frame.size.height
        }

        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        let finalFrame = isPresentation ? presentedFrame : dismissedFrame

        let animationDuration = transitionDuration(using: transitionContext)
        controller.view.frame = initialFrame
        UIView.animate(withDuration: animationDuration, animations: {
            controller.view.frame = finalFrame
        }) { finished in
            transitionContext.completeTransition(finished)
        }
    }
}


extension NSLayoutConstraint {

    /// Create an array of constraints using an ASCII art-like visual format string.
    ///
    /// - Parameters:
    ///   - format: The visual format string.
    ///   - views: A dictionary that maps view identifiers in `format` with
    ///            view objects.
    /// - Returns: An `Array` of `NSLayoutConstraint`s to satisfy the format.
    public class func constraints(withVisualFormat format: String,
                                  views: [String : Any]) -> [NSLayoutConstraint] {
        return self.constraints(withVisualFormat: format,
                                options: [],
                                metrics: nil,
                                views: views)
    }

    /// Convenience method that activates each constraint in the contained
    /// arrays, in the same manner as setting `active=YES` on each constraint.
    /// This is often more efficient than activating each constraint
    /// individually.
    ///
    /// - Parameter constraintArrays: An array of arrays containing
    ///                               `NSLayoutConstraint`s.
    public class func activate(_ constraintArrays: [[NSLayoutConstraint]]) {
        self.activate(constraintArrays.flatMap { $0 })
    }

}

extension UIEdgeInsets {

    /// Initializes a `UIEdgeInsets` with a constant value for `top`, `left`,
    /// `bottom`, and `right`.
    ///
    /// - Parameter constant: The constant value to use for all four dimensions.
    public init(constant: CGFloat) {
        self.init(top: constant,
                  left: constant,
                  bottom: constant,
                  right: constant)
    }

    /// Forms a union with the given edge insets. Each value in the insets will
    /// be the larger of the two values.
    ///
    /// - Parameter otherInsets: The other insets with which to form a union.
    public mutating func formUnion(with otherInsets: UIEdgeInsets) {
        top = max(top, otherInsets.top)
        left = max(left, otherInsets.left)
        bottom = max(bottom, otherInsets.bottom)
        right = max(right, otherInsets.right)
    }

}

extension UIViewController {

    /// Returns `true` if the `width` and `height` of the view controller’s
    /// `preferredContentSize` are both larger than `0`.
    var hasPreferredContentSize: Bool {
        return preferredContentSize.width > 0 && preferredContentSize.height > 0
    }

}
