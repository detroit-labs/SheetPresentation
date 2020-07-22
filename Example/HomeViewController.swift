//
//  HomeViewController.swift
//  SheetPresentation
//
//  Created by Jeff Kelley on 7/17/18.
//  Copyright © 2020 Detroit Labs, LLC. All rights reserved.
//

import UIKit
import SheetPresentation

// swiftlint:disable:next type_body_length
class HomeViewController: UIViewController {

    lazy var wholeNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    // MARK: - Corner Options
    @IBOutlet var cornerRadiusStackView: UIStackView!
    @IBOutlet var roundCornersSwitch: UISwitch!
    @IBOutlet var cornerRadiusSlider: UISlider!
    @IBOutlet var cornerRadiusValueLabel: UILabel!
    @IBOutlet var cornerSelectionSegmentedControl: UISegmentedControl!
    @IBOutlet var cornerSelectionStackView: UIStackView!
    @IBOutlet var topLeftCornerSwitch: UISwitch!
    @IBOutlet var topRightCornerSwitch: UISwitch!
    @IBOutlet var bottomLeftCornerSwitch: UISwitch!
    @IBOutlet var bottomRightCornerSwitch: UISwitch!

    func cornerOptionsForUISelections(
    ) -> SheetPresentationOptions.CornerOptions {
        if roundCornersSwitch.isOn {
            let radius = CGFloat(cornerRadiusSlider.value)

            if cornerSelectionSegmentedControl.selectedSegmentIndex == 0 {
                return .roundAllCorners(radius: radius)
            }
            else {
                var mask = CACornerMask()

                if topLeftCornerSwitch.isOn {
                    mask.insert(.layerMinXMinYCorner)
                }

                if topRightCornerSwitch.isOn {
                    mask.insert(.layerMaxXMinYCorner)
                }

                if bottomLeftCornerSwitch.isOn {
                    mask.insert(.layerMinXMaxYCorner)
                }

                if bottomRightCornerSwitch.isOn {
                    mask.insert(.layerMaxXMaxYCorner)
                }

                return .roundSomeCorners(radius: radius, corners: mask)
            }
        }
        else {
            return .none
        }
    }

    @IBAction func userToggledRoundCornersSwitch(_ sender: UISwitch) {
        cornerRadiusStackView.isHidden = !sender.isOn
    }

    @IBAction func userAdjustedCornerRadiusSlider(_ sender: UISlider) {
        sender.value = round(sender.value)

        cornerRadiusValueLabel.text = wholeNumberFormatter.string(
            from: NSNumber(value: sender.value)
        )
    }

    @IBAction func userSelectedCornerSelection(_ sender: UISegmentedControl) {
        cornerSelectionStackView.isHidden = (sender.selectedSegmentIndex == 0)
    }

    // MARK: - Dimming View Alpha
    @IBOutlet var useDimmingViewStackView: UIStackView!
    @IBOutlet var useDimmingViewSwitch: UISwitch!
    @IBOutlet var useDimmingViewAlphaSlider: UISlider!

    func dimmingViewAlphaForUISelections() -> CGFloat? {
        if useDimmingViewSwitch.isOn {
            return CGFloat(useDimmingViewAlphaSlider.value)
        }
        else {
            return nil
        }
    }

    @IBAction func userToggledUseDimmingViewSwitch(_ sender: UISwitch) {
        useDimmingViewStackView.isHidden = !sender.isOn
    }

    // MARK: - Edge Insets
    @IBOutlet var edgeInsetsTypeSegmentedControl: UISegmentedControl!
    @IBOutlet var topEdgeInsetSlider: UISlider!
    @IBOutlet var topEdgeInsetValueLabel: UILabel!
    @IBOutlet var leadingLeftEdgeInsetLabel: UILabel!
    @IBOutlet var leadingLeftEdgeInsetSlider: UISlider!
    @IBOutlet var leadingLeftEdgeInsetValueLabel: UILabel!
    @IBOutlet var trailingRightEdgeInsetLabel: UILabel!
    @IBOutlet var trailingRightEdgeInsetSlider: UISlider!
    @IBOutlet var trailingRightEdgeInsetValueLabel: UILabel!
    @IBOutlet var bottomEdgeInsetSlider: UISlider!
    @IBOutlet var bottomEdgeInsetValueLabel: UILabel!

    func edgeInsetsForUISelections() -> DirectionalEdgeInsetsConvertible {
        if edgeInsetsTypeSegmentedControl.selectedSegmentIndex == 0 {
            return NSDirectionalEdgeInsets(
                top: CGFloat(topEdgeInsetSlider.value),
                leading: CGFloat(leadingLeftEdgeInsetSlider.value),
                bottom: CGFloat(bottomEdgeInsetSlider.value),
                trailing: CGFloat(trailingRightEdgeInsetSlider.value)
            )
        }
        else {
            return UIEdgeInsets(
                top: CGFloat(topEdgeInsetSlider.value),
                left: CGFloat(leadingLeftEdgeInsetSlider.value),
                bottom: CGFloat(bottomEdgeInsetSlider.value),
                right: CGFloat(trailingRightEdgeInsetSlider.value)
            )
        }
    }

    @IBAction func userSelectedEdgeInsetsType(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            leadingLeftEdgeInsetLabel.text = "Leading"
            trailingRightEdgeInsetLabel.text = "Trailing"
        }
        else {
            leadingLeftEdgeInsetLabel.text = "Left"
            trailingRightEdgeInsetLabel.text = "Right"
        }
    }

    @IBAction func userAdjustedTopEdgeInsetSlider(_ sender: UISlider) {
        sender.value = round(sender.value)

        topEdgeInsetValueLabel.text = wholeNumberFormatter.string(
            from: NSNumber(value: sender.value)
        )
    }

    @IBAction func userAdjustedLeadingLeftValueSlider(_ sender: UISlider) {
        sender.value = round(sender.value)

        leadingLeftEdgeInsetValueLabel.text = wholeNumberFormatter.string(
            from: NSNumber(value: sender.value)
        )
    }

    @IBAction func userAdjustedTrailingRightEdgeInsetSlider(
        _ sender: UISlider
    ) {
        sender.value = round(sender.value)

        trailingRightEdgeInsetValueLabel.text = wholeNumberFormatter.string(
            from: NSNumber(value: sender.value)
        )
    }

    @IBAction func userAdjustedBottomEdgeInsetSlider(_ sender: UISlider) {
        sender.value = round(sender.value)

        bottomEdgeInsetValueLabel.text = wholeNumberFormatter.string(
            from: NSNumber(value: sender.value)
        )
    }

    // MARK: - Ignored Edges for Margins
    @IBOutlet var ignoreTopEdgeSwitch: UISwitch!
    @IBOutlet var ignoreLeadingEdgeSwitch: UISwitch!
    @IBOutlet var ignoreTrailingEdgeSwitch: UISwitch!
    @IBOutlet var ignoreBottomEdgeSwitch: UISwitch!

    func ignoredEdgesForMarginsForUISelections() -> [ViewEdge] {
        var ignoredEdges: [ViewEdge] = []

        if ignoreTopEdgeSwitch.isOn { ignoredEdges.append(.top) }

        if ignoreLeadingEdgeSwitch.isOn { ignoredEdges.append(.leading) }

        if ignoreTrailingEdgeSwitch.isOn { ignoredEdges.append(.trailing) }

        if ignoreBottomEdgeSwitch.isOn { ignoredEdges.append(.bottom) }

        return ignoredEdges
    }

    // MARK: - Presentation Layout
    @IBOutlet var presentationLayoutTypeSegmentedControl: UISegmentedControl!
    @IBOutlet var horizontalSizingBehaviorSegmentedControl: UISegmentedControl!
    @IBOutlet var horizontalSizingBehaviorStackView: UIStackView!
    @IBOutlet var horizontalAlignmentSegmentedControl: UISegmentedControl!
    @IBOutlet var horizontalAlignmentStackView: UIStackView!
    @IBOutlet var verticalSizingBehaviorSegmentedControl: UISegmentedControl!
    @IBOutlet var verticalSizingBehaviorStackView: UIStackView!
    @IBOutlet var verticalAlignmentSegmentedControl: UISegmentedControl!
    @IBOutlet var verticalAlignmentStackView: UIStackView!

    func horizontalAlignmentForUISelections(
    ) -> PresentationLayout.HorizontalAlignment {
        switch horizontalAlignmentSegmentedControl.selectedSegmentIndex {
        case 0: return .leading
        case 1: return .center
        case 2: return .trailing
        case 3: return .left
        case 4: return .right
        default:
            fatalError(
                "Unexpected value for horizontalAlignmentSegmentedControl"
            )
        }
    }

    func horizontalSizingBehaviorForUISelections(
    ) -> PresentationLayout.HorizontalSizingBehavior {
        if horizontalSizingBehaviorSegmentedControl.selectedSegmentIndex == 0 {
            return .automatic(alignment: horizontalAlignmentForUISelections())
        }
        else {
            return .fill
        }
    }

    func verticalAlignmentForUISelections(
    ) -> PresentationLayout.VerticalAlignment {
        switch verticalAlignmentSegmentedControl.selectedSegmentIndex {
        case 0: return .top
        case 1: return .middle
        case 2: return .bottom
        default:
            fatalError("Unexpected value for verticalAlignmentSegmentedControl")
        }
    }

    func verticalSizingBehaviorForUISelections(
    ) -> PresentationLayout.VerticalSizingBehavior {
        if verticalSizingBehaviorSegmentedControl.selectedSegmentIndex == 0 {
            return .automatic(alignment: verticalAlignmentForUISelections())
        }
        else {
            return .fill
        }
    }

    func presentationLayoutForUISelections() -> PresentationLayout {
        switch presentationLayoutTypeSegmentedControl.selectedSegmentIndex {
        case 0: return .leading(horizontalSizingBehaviorForUISelections())
        case 1: return .trailing(horizontalSizingBehaviorForUISelections())
        case 2: return .top(verticalSizingBehaviorForUISelections())
        case 3: return .bottom(verticalSizingBehaviorForUISelections())
        case 4: return .overlay(horizontalSizingBehaviorForUISelections(),
                                verticalSizingBehaviorForUISelections())
        case 5: return .left(horizontalSizingBehaviorForUISelections())
        case 6: return .right(horizontalSizingBehaviorForUISelections())
        default:
            fatalError(
                "Unexpected value for presentationLayoutTypeSegmentedControl"
            )
        }
    }

    @IBAction func userSelectedPresentationLayoutType(
        _ sender: UISegmentedControl
    ) {
        switch sender.selectedSegmentIndex {
        case 0, 1, 5, 6:
            horizontalSizingBehaviorStackView.isHidden = false
            horizontalAlignmentStackView.isHidden =
                (horizontalSizingBehaviorSegmentedControl.selectedSegmentIndex
                    != 0)
            verticalSizingBehaviorStackView.isHidden = true
            verticalAlignmentStackView.isHidden = true
        case 2, 3:
            horizontalSizingBehaviorStackView.isHidden = true
            horizontalAlignmentStackView.isHidden = true
            verticalSizingBehaviorStackView.isHidden = false
            verticalAlignmentStackView.isHidden =
                (verticalSizingBehaviorSegmentedControl.selectedSegmentIndex
                    != 0)
        case 4:
            horizontalSizingBehaviorStackView.isHidden = false
            horizontalAlignmentStackView.isHidden =
                (horizontalSizingBehaviorSegmentedControl.selectedSegmentIndex
                    != 0)
            verticalSizingBehaviorStackView.isHidden = false
            verticalAlignmentStackView.isHidden =
                (verticalSizingBehaviorSegmentedControl.selectedSegmentIndex
                    != 0)
        default:
            fatalError(
                "Unexpected value for presentationLayoutTypeSegmentedControl"
            )
        }
    }

    @IBAction func userSelectedHorizontalSizingBehavior(
        _ sender: UISegmentedControl
    ) {
        horizontalAlignmentStackView.isHidden = sender.selectedSegmentIndex != 0
    }

    @IBAction func userSelectedVerticalSizingBehavior(
        _ sender: UISegmentedControl
    ) {
        verticalAlignmentStackView.isHidden = sender.selectedSegmentIndex != 0
    }

    // MARK: -

    var presentationManager: SheetPresentationManager?

    func presentationOptionsForUISelections() -> SheetPresentationOptions {
        return SheetPresentationOptions(
            cornerOptions: cornerOptionsForUISelections(),
            dimmingViewAlpha: dimmingViewAlphaForUISelections(),
            edgeInsets: edgeInsetsForUISelections(),
            ignoredEdgesForMargins: ignoredEdgesForMarginsForUISelections(),
            presentationLayout: presentationLayoutForUISelections()
        )
    }

    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentChild" {
            let options = presentationOptionsForUISelections()
            let presentationManager = SheetPresentationManager(options: options)

            segue.destination.transitioningDelegate = presentationManager
            segue.destination.modalPresentationStyle = .custom

            self.presentationManager = presentationManager
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }

}
