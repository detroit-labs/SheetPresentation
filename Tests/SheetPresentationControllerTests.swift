//
//  SheetPresentationControllerTests.swift
//  SheetPresentationTests
//
//  Created by Jeff Kelley on 8/25/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

@testable import SheetPresentation

import UIKit
import XCTest

extension UIPresentationController {

    func setContainerView(_ containerView: UIView) {
        // UIKit automatically sets the containerView property during the UI
        // process, but since we’re not running in a UI test, we have to set it
        // manually; and since it’s read-only, we have to use key-value coding
        // to set it.
        setValue(containerView, forKeyPath: "containerView")
    }

}

final class SheetPresentationControllerTests: XCTestCase {

    func testTheDefaultTapHandlerDismissesTheView() throws {
        let manager = SheetPresentationManager()

        let presented = MockViewController()
        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
            ) as? SheetPresentationController
        )

        controller.userTappedInDimmingArea(UITapGestureRecognizer())

        XCTAssertTrue(try XCTUnwrap(presented.dismissWasAnimated))
    }

    func testATargetActionDismissal() throws {
        let presented = MockViewController()

        let handler = DimmingViewTapHandler.targetAction(
            presented,
            #selector(MockViewController.mockAction)
        )

        let manager = SheetPresentationManager(dimmingViewTapHandler: handler)

        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
            ) as? SheetPresentationController
        )

        controller.userTappedInDimmingArea(UITapGestureRecognizer())

        XCTAssertEqual(presented.receivedSenderForAction as? MockViewController,
                       presented)
    }

    func testPassthroughViewPassesTouchesToPresentingViewController() throws {
        let presented = MockViewController()

        let manager = SheetPresentationManager(
            options: SheetPresentationOptions(dimmingViewAlpha: nil)
        )

        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: source,
                source: source
            ) as? SheetPresentationController
        )

        XCTAssertEqual(controller.passthroughView?.passthroughViews,
                       [source.view])
    }

}

// swiftlint:disable file_length
// swiftlint:disable:next type_name type_body_length
final class SheetPresentationControllerContentContainerTests: XCTestCase {

    // MARK: - viewWillTransition(to:with:)

    func testSizeTransitionsCallSuper() throws {
        let manager = SheetPresentationManager()

        let presented = MockViewController()
        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
            ) as? SheetPresentationController
        )

        let selector = #selector(
            SheetPresentationController.viewWillTransition(to:with:)
        )

        let expect = expectationThatSuperIsCalled(object: controller,
                                                  selector: selector)

        let size = CGSize(width: 42, height: 42)
        let coordinator = MockTransitionCoordinator()

        controller.viewWillTransition(to: size, with: coordinator)

        wait(for: [expect], timeout: 2)
    }

    func testSizeTransitionExecutesAnimation() throws {
        let manager = SheetPresentationManager()

        let presented = MockViewController()
        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
                ) as? SheetPresentationController
        )

        let size = CGSize(width: 42, height: 42)
        let coordinator = MockTransitionCoordinator()
        coordinator.containerView.bounds.size = size

        controller.viewWillTransition(to: size, with: coordinator)

        XCTAssertNotNil(coordinator.animateAlongsideTransitionAnimation)

        coordinator.animateAlongsideTransitionAnimation?(coordinator)

        XCTAssertEqual(
            presented.view.frame,
            coordinator.containerView.bounds.inset(
                by: manager.presentationOptions.edgeInsets.fixedEdgeInsets(
                    for: nil
                )
            )
        )
    }

    // MARK: - willTransition(to:with:)

    func testTraitTransitionsCallSuper() throws {
        let manager = SheetPresentationManager()

        let presented = UIViewController()
        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
            )
        )

        let selector = #selector(
            SheetPresentationController.willTransition(to:with:)
        )

        let expect = self.expectationThatSuperIsCalled(
            object: controller,
            selector: selector
        )

        controller.willTransition(to: UITraitCollection(),
                                  with: MockTransitionCoordinator())

        wait(for: [expect], timeout: 2)
    }

    func testTraitTransitionExecutesAnimation() throws {
        let manager = SheetPresentationManager()

        let presented = MockViewController()
        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
                ) as? SheetPresentationController
        )

        let size = CGSize(width: 42, height: 42)
        let coordinator = MockTransitionCoordinator()
        coordinator.containerView.bounds.size = size

        controller.willTransition(to: UITraitCollection(), with: coordinator)

        XCTAssertNotNil(coordinator.animateAlongsideTransitionAnimation)

        coordinator.animateAlongsideTransitionAnimation?(coordinator)

        XCTAssertEqual(
            presented.view.frame,
            coordinator.containerView.bounds.inset(
                by: manager.presentationOptions.edgeInsets.fixedEdgeInsets(
                    for: nil
                )
            )
        )
    }

    // MARK: - size(forChildContentContainer:withParentContainerSize:)

    func testAllLayoutsUsePreferredContentSizeIfSet() {
        let allHorizontalLayouts = [PresentationLayout.HorizontalLayout.fill] +
            PresentationLayout.HorizontalAlignment.allCases.map {
                PresentationLayout.HorizontalLayout.automatic(alignment: $0)
        }

        let allVerticalLayouts = [PresentationLayout.VerticalLayout.fill] +
            PresentationLayout.VerticalAlignment.allCases.map {
                PresentationLayout.VerticalLayout.automatic(alignment: $0)
        }

        for horizontalLayout in allHorizontalLayouts {
            for verticalLayout in allVerticalLayouts {
                let manager = SheetPresentationManager(
                    options: SheetPresentationOptions(
                        presentationLayout: PresentationLayout(
                            horizontalLayout: horizontalLayout,
                            verticalLayout: verticalLayout
                        )
                    )
                )

                let presented = UIViewController()
                let source = UIViewController()

                let controller = manager.presentationController(
                    forPresented: presented,
                    presenting: nil,
                    source: source
                )

                let preferredContentSize = CGSize(width: 42, height: 42)

                presented.preferredContentSize = preferredContentSize

                let parentSize = CGSize(width: 100, height: 100)

                XCTAssertEqual(
                    controller?.size(forChildContentContainer: presented,
                                     withParentContainerSize: parentSize),
                    preferredContentSize
                )
            }
        }
    }

    func testFillingTheContainerWithTheChild() {
        let manager = SheetPresentationManager(
            options: SheetPresentationOptions(
                presentationLayout: PresentationLayout(
                    horizontalLayout: .fill,
                    verticalLayout: .fill
                )
            )
        )

        let presented = UIViewController()
        let source = UIViewController()

        let controller = manager.presentationController(forPresented: presented,
                                                        presenting: nil,
                                                        source: source)

        let expectedSize = CGSize(width: 42, height: 42)

        XCTAssertEqual(controller?.size(forChildContentContainer: presented,
                                        withParentContainerSize: expectedSize),
                       expectedSize)
    }

    func testFullyAutomaticLayoutsSizeThemselves() {
        let allHorizontalLayouts =
            PresentationLayout.HorizontalAlignment.allCases.map {
                PresentationLayout.HorizontalLayout.automatic(alignment: $0)
        }

        let allVerticalLayouts =
            PresentationLayout.VerticalAlignment.allCases.map {
                PresentationLayout.VerticalLayout.automatic(alignment: $0)
        }

        for horizontalLayout in allHorizontalLayouts {
            for verticalLayout in allVerticalLayouts {
                let manager = SheetPresentationManager(
                    options: SheetPresentationOptions(
                        presentationLayout: PresentationLayout(
                            horizontalLayout: horizontalLayout,
                            verticalLayout: verticalLayout
                        )
                    )
                )

                let presented = MockSizableViewController()

                let layoutSize = CGSize(width: 42, height: 42)
                let parentSize = CGSize(width: 100, height: 100)

                presented.set(layoutSize: layoutSize,
                              forTargetSize: UIView.layoutFittingCompressedSize,
                              horizontalFittingPriority: .defaultLow,
                              verticalFittingPriority: .defaultLow)

                let source = UIViewController()

                let controller = manager.presentationController(
                    forPresented: presented,
                    presenting: nil,
                    source: source
                )

                XCTAssertEqual(
                    controller?.size(forChildContentContainer: presented,
                                     withParentContainerSize: parentSize),
                    layoutSize
                )
            }
        }
    }

    func testHorizontalFillVerticalAutomaticLayoutsSizeThemselves() {
        let allVerticalLayouts =
            PresentationLayout.VerticalAlignment.allCases.map {
                PresentationLayout.VerticalLayout.automatic(alignment: $0)
        }

        for verticalLayout in allVerticalLayouts {
            let manager = SheetPresentationManager(
                options: SheetPresentationOptions(
                    presentationLayout: PresentationLayout(
                        horizontalLayout: .fill,
                        verticalLayout: verticalLayout
                    )
                )
            )

            let presented = MockSizableViewController()

            let layoutSize = CGSize(width: 42, height: 42)
            let parentSize = CGSize(width: 100, height: 100)

            presented.set(
                layoutSize: layoutSize,
                forTargetSize: CGSize(
                    width: parentSize.width,
                    height: UIView.layoutFittingCompressedSize.height
                ),
                horizontalFittingPriority: .required,
                verticalFittingPriority: .defaultLow
            )

            let source = UIViewController()

            let controller = manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
            )

            XCTAssertEqual(
                controller?.size(forChildContentContainer: presented,
                                 withParentContainerSize: parentSize),
                layoutSize
            )
        }
    }

    func testHorizontalAutomaticVerticalFillLayoutsSizeThemselves() {
        let allHorizontalLayouts =
            PresentationLayout.HorizontalAlignment.allCases.map {
                PresentationLayout.HorizontalLayout.automatic(alignment: $0)
        }

        for horizontalLayout in allHorizontalLayouts {
            let manager = SheetPresentationManager(
                options: SheetPresentationOptions(
                    presentationLayout: PresentationLayout(
                        horizontalLayout: horizontalLayout,
                        verticalLayout: .fill
                    )
                )
            )

            let presented = MockSizableViewController()

            let layoutSize = CGSize(width: 42, height: 42)
            let parentSize = CGSize(width: 100, height: 100)

            presented.set(
                layoutSize: layoutSize,
                forTargetSize: CGSize(
                    width: UIView.layoutFittingCompressedSize.width,
                    height: parentSize.height
                ),
                horizontalFittingPriority: .defaultLow,
                verticalFittingPriority: .required
            )

            let source = UIViewController()

            let controller = manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
            )

            XCTAssertEqual(
                controller?.size(forChildContentContainer: presented,
                                 withParentContainerSize: parentSize),
                layoutSize
            )
        }
    }

    func testHorizontalSizingCannotExceedParentalWidth() {
        let allHorizontalLayouts =
            PresentationLayout.HorizontalAlignment.allCases.map {
                PresentationLayout.HorizontalLayout.automatic(alignment: $0)
        }

        let allVerticalLayouts =
            PresentationLayout.VerticalAlignment.allCases.map {
                PresentationLayout.VerticalLayout.automatic(alignment: $0)
        }

        for horizontalLayout in allHorizontalLayouts {
            for verticalLayout in allVerticalLayouts {
                let manager = SheetPresentationManager(
                    options: SheetPresentationOptions(
                        presentationLayout: PresentationLayout(
                            horizontalLayout: horizontalLayout,
                            verticalLayout: verticalLayout
                        )
                    )
                )

                let presented = MockSizableViewController()

                let layoutSize = CGSize(width: 420, height: 42)
                let parentSize = CGSize(width: 100, height: 100)
                let fixedSize = CGSize(width: parentSize.width,
                                       height: layoutSize.height)

                presented.set(layoutSize: layoutSize,
                              forTargetSize: UIView.layoutFittingCompressedSize,
                              horizontalFittingPriority: .defaultLow,
                              verticalFittingPriority: .defaultLow)

                presented.set(
                    layoutSize: fixedSize,
                    forTargetSize: CGSize(
                        width: parentSize.width,
                        height: UIView.layoutFittingCompressedSize.height
                    ),
                    horizontalFittingPriority: .required,
                    verticalFittingPriority: .defaultLow
                )

                let source = UIViewController()

                let controller = manager.presentationController(
                    forPresented: presented,
                    presenting: nil,
                    source: source
                )

                XCTAssertEqual(
                    controller?.size(forChildContentContainer: presented,
                                     withParentContainerSize: parentSize),
                    fixedSize
                )
            }
        }
    }

    func testVerticalSizingCannotExceedParentalHeight() {
        let allHorizontalLayouts =
            PresentationLayout.HorizontalAlignment.allCases.map {
                PresentationLayout.HorizontalLayout.automatic(alignment: $0)
        }

        let allVerticalLayouts =
            PresentationLayout.VerticalAlignment.allCases.map {
                PresentationLayout.VerticalLayout.automatic(alignment: $0)
        }

        for horizontalLayout in allHorizontalLayouts {
            for verticalLayout in allVerticalLayouts {
                let manager = SheetPresentationManager(
                    options: SheetPresentationOptions(
                        presentationLayout: PresentationLayout(
                            horizontalLayout: horizontalLayout,
                            verticalLayout: verticalLayout
                        )
                    )
                )

                let presented = MockSizableViewController()

                let layoutSize = CGSize(width: 42, height: 420)
                let parentSize = CGSize(width: 100, height: 100)
                let fixedSize = CGSize(width: layoutSize.width,
                                       height: parentSize.height)

                presented.set(layoutSize: layoutSize,
                              forTargetSize: UIView.layoutFittingCompressedSize,
                              horizontalFittingPriority: .defaultLow,
                              verticalFittingPriority: .defaultLow)

                presented.set(
                    layoutSize: fixedSize,
                    forTargetSize: CGSize(
                        width: UIView.layoutFittingCompressedSize.width,
                        height: parentSize.height
                    ),
                    horizontalFittingPriority: .defaultLow,
                    verticalFittingPriority: .required
                )

                let source = UIViewController()

                let controller = manager.presentationController(
                    forPresented: presented,
                    presenting: nil,
                    source: source
                )

                XCTAssertEqual(
                    controller?.size(forChildContentContainer: presented,
                                     withParentContainerSize: parentSize),
                    fixedSize
                )
            }
        }
    }

    // MARK: - preferredContentSizeDidChange(forChildContentContainer:)

    func testPreferredContentSizeDidChangeCallsSuper() throws {
        let manager = SheetPresentationManager()

        let presented = MockViewController()
        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
            ) as? SheetPresentationController
        )

        let selector = #selector(
            SheetPresentationController.preferredContentSizeDidChange(
                forChildContentContainer:
            )
        )

        let expect = expectationThatSuperIsCalled(object: controller,
                                                  selector: selector)

        controller.preferredContentSizeDidChange(
            forChildContentContainer: presented
        )

        wait(for: [expect], timeout: 2)
    }

    func testPreferredContentSizeChangesResultInLayout() throws {
        let manager = SheetPresentationManager()

        let presented = MockViewController()
        presented.loadViewIfNeeded()

        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
            ) as? SheetPresentationController
        )

        let containerView = UIView()
        containerView.frame.size = CGSize(width: 42, height: 42)

        controller.setContainerView(containerView)

        // Confirm that the view controller’s view is still the default size so
        // that we know the following method call is what changed its bounds.
        XCTAssertEqual(presented.view.frame, UIScreen.main.bounds)

        controller.preferredContentSizeDidChange(
            forChildContentContainer: presented
        )

        XCTAssertEqual(presented.view.frame,
                       controller.frameOfPresentedViewInContainerView)
    }

    // MARK: - systemLayoutFittingSizeDidChange(forChildContentContainer:)

    func testSystemLayoutFittingSizeDidChangeCallsSuper() throws {
        let manager = SheetPresentationManager()

        let presented = MockViewController()
        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
            ) as? SheetPresentationController
        )

        let selector = #selector(
            SheetPresentationController.systemLayoutFittingSizeDidChange(
                forChildContentContainer:
            )
        )

        let expect = expectationThatSuperIsCalled(object: controller,
                                                  selector: selector)

        controller.systemLayoutFittingSizeDidChange(
            forChildContentContainer: presented
        )

        wait(for: [expect], timeout: 2)
    }

    func testSystemLayoutFittingSizeChangesResultInLayout() throws {
        let manager = SheetPresentationManager()

        let presented = MockViewController()
        presented.loadViewIfNeeded()

        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
            ) as? SheetPresentationController
        )

        let containerView = UIView()
        containerView.frame.size = CGSize(width: 42, height: 42)

        controller.setContainerView(containerView)

        // Confirm that the view controller’s view is still the default size so
        // that we know the following method call is what changed its bounds.
        XCTAssertEqual(presented.view.frame, UIScreen.main.bounds)

        controller.systemLayoutFittingSizeDidChange(
            forChildContentContainer: presented
        )

        XCTAssertEqual(presented.view.frame,
                       controller.frameOfPresentedViewInContainerView)
    }

}

// swiftlint:disable:next type_name type_body_length
final class SheetPresentationControllerPresentationControllerTests: XCTestCase {

    // MARK: - frameOfPresentedViewInContainerView

    func testAllLayoutsClampSizeToContainerViewBounds() throws {
        let allHorizontalLayouts = [PresentationLayout.HorizontalLayout.fill] +
            PresentationLayout.HorizontalAlignment.allCases.map {
                PresentationLayout.HorizontalLayout.automatic(alignment: $0)
        }

        let allVerticalLayouts = [PresentationLayout.VerticalLayout.fill] +
            PresentationLayout.VerticalAlignment.allCases.map {
                PresentationLayout.VerticalLayout.automatic(alignment: $0)
        }

        for horizontalLayout in allHorizontalLayouts {
            for verticalLayout in allVerticalLayouts {
                let manager = SheetPresentationManager(
                    options: SheetPresentationOptions(
                        presentationLayout: PresentationLayout(
                            horizontalLayout: horizontalLayout,
                            verticalLayout: verticalLayout
                        )
                    )
                )

                let presented = UIViewController()
                let source = UIViewController()

                let controller = try XCTUnwrap(
                    manager.presentationController(
                        forPresented: presented,
                        presenting: nil,
                        source: source
                    ) as? SheetPresentationController
                )

                let preferredContentSize = CGSize(width: 100, height: 100)

                presented.preferredContentSize = preferredContentSize

                let parentSize = CGSize(width: 42, height: 42)

                let containerView = UIView()
                containerView.frame.size = parentSize

                controller.setContainerView(containerView)

                let frame = controller.frameOfPresentedViewInContainerView

                XCTAssertEqual(
                    frame,
                    containerView.bounds.inset(
                        by: controller.marginAdjustedEdgeInsets(
                            for: containerView.layoutMargins
                        )
                    )
                )
            }
        }
    }

    func testLayoutsThatPlaceThePresentedViewAtMinX() throws {
        let tests: [(PresentationLayout.HorizontalLayout, UITraitCollection?)] =
            [(.fill, nil),
             (.automatic(alignment: .leading),
              UITraitCollection(layoutDirection: .leftToRight)),
             (.automatic(alignment: .trailing),
              UITraitCollection(layoutDirection: .rightToLeft)),
             (.automatic(alignment: .left), nil)]

        for (layout, traitCollection) in tests {
            let manager = SheetPresentationManager(
                options: SheetPresentationOptions(
                    presentationLayout: PresentationLayout(
                        horizontalLayout: layout,
                        verticalLayout: .fill
                    )
                )
            )

            let presented = UIViewController()
            let source = UIViewController()

            let controller = try XCTUnwrap(
                manager.presentationController(
                    forPresented: presented,
                    presenting: nil,
                    source: source
                ) as? SheetPresentationController
            )

            let preferredContentSize = CGSize(width: 42, height: 42)

            presented.preferredContentSize = preferredContentSize

            let parentSize = CGSize(width: 1000, height: 1000)

            let containerView = UIView()
            containerView.frame.size = parentSize

            controller.setContainerView(containerView)
            controller.overrideTraitCollection = traitCollection

            let frame = controller.frameOfPresentedViewInContainerView

            XCTAssertEqual(
                frame.minX,
                containerView.bounds.inset(
                    by: controller.marginAdjustedEdgeInsets(
                        for: containerView.layoutMargins
                    )
                ).minX
            )
        }
    }

    func testLayoutThatPlacesThePresentedViewAtMidX() throws {
        let manager = SheetPresentationManager(
            options: SheetPresentationOptions(
                presentationLayout: PresentationLayout(
                    horizontalLayout: .automatic(alignment: .center),
                    verticalLayout: .fill
                )
            )
        )

        let presented = UIViewController()
        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
            ) as? SheetPresentationController
        )

        let preferredContentSize = CGSize(width: 42, height: 42)

        presented.preferredContentSize = preferredContentSize

        let parentSize = CGSize(width: 1000, height: 1000)

        let containerView = UIView()
        containerView.frame.size = parentSize

        controller.setContainerView(containerView)

        let frame = controller.frameOfPresentedViewInContainerView

        XCTAssertEqual(
            frame.midX,
            containerView.bounds.inset(
                by: controller.marginAdjustedEdgeInsets(
                    for: containerView.layoutMargins
                )
            ).midX
        )
    }

    func testLayoutsThatPlaceThePresentedViewAtMaxX() throws {
        let tests: [(PresentationLayout.HorizontalLayout, UITraitCollection?)] =
            [(.automatic(alignment: .leading),
              UITraitCollection(layoutDirection: .rightToLeft)),
             (.automatic(alignment: .trailing),
              UITraitCollection(layoutDirection: .leftToRight)),
             (.automatic(alignment: .right), nil)]

        for (layout, traitCollection) in tests {
            let manager = SheetPresentationManager(
                options: SheetPresentationOptions(
                    presentationLayout: PresentationLayout(
                        horizontalLayout: layout,
                        verticalLayout: .fill
                    )
                )
            )

            let presented = UIViewController()
            let source = UIViewController()

            let controller = try XCTUnwrap(
                manager.presentationController(
                    forPresented: presented,
                    presenting: nil,
                    source: source
                ) as? SheetPresentationController
            )

            let preferredContentSize = CGSize(width: 42, height: 42)

            presented.preferredContentSize = preferredContentSize

            let parentSize = CGSize(width: 1000, height: 1000)

            let containerView = UIView()
            containerView.frame.size = parentSize

            controller.setContainerView(containerView)
            controller.overrideTraitCollection = traitCollection

            let frame = controller.frameOfPresentedViewInContainerView

            XCTAssertEqual(
                frame.maxX,
                containerView.bounds.inset(
                    by: controller.marginAdjustedEdgeInsets(
                        for: containerView.layoutMargins
                    )
                ).maxX
            )
        }
    }

    func testLayoutsThatPlaceThePresentedViewAtMinY() throws {
        let tests: [PresentationLayout.VerticalLayout] =
            [.fill, .automatic(alignment: .top)]

        for layout in tests {
            let manager = SheetPresentationManager(
                options: SheetPresentationOptions(
                    presentationLayout: PresentationLayout(
                        horizontalLayout: .fill,
                        verticalLayout: layout
                    )
                )
            )

            let presented = UIViewController()
            let source = UIViewController()

            let controller = try XCTUnwrap(
                manager.presentationController(
                    forPresented: presented,
                    presenting: nil,
                    source: source
                ) as? SheetPresentationController
            )

            let preferredContentSize = CGSize(width: 42, height: 42)

            presented.preferredContentSize = preferredContentSize

            let parentSize = CGSize(width: 1000, height: 1000)

            let containerView = UIView()
            containerView.frame.size = parentSize

            controller.setContainerView(containerView)

            let frame = controller.frameOfPresentedViewInContainerView

            XCTAssertEqual(
                frame.minY,
                containerView.bounds.inset(
                    by: controller.marginAdjustedEdgeInsets(
                        for: containerView.layoutMargins
                    )
                ).minY
            )
        }
    }

    func testLayoutThatPlacesThePresentedViewAtMidY() throws {
        let manager = SheetPresentationManager(
            options: SheetPresentationOptions(
                presentationLayout: PresentationLayout(
                    horizontalLayout: .fill,
                    verticalLayout: .automatic(alignment: .middle)
                )
            )
        )

        let presented = UIViewController()
        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
            ) as? SheetPresentationController
        )

        let preferredContentSize = CGSize(width: 42, height: 42)

        presented.preferredContentSize = preferredContentSize

        let parentSize = CGSize(width: 1000, height: 1000)

        let containerView = UIView()
        containerView.frame.size = parentSize

        controller.setContainerView(containerView)

        let frame = controller.frameOfPresentedViewInContainerView

        XCTAssertEqual(
            frame.midY,
            containerView.bounds.inset(
                by: controller.marginAdjustedEdgeInsets(
                    for: containerView.layoutMargins
                )
            ).midY
        )
    }

    func testLayoutThatPlacesThePresentedViewAtMaxY() throws {
        let manager = SheetPresentationManager(
            options: SheetPresentationOptions(
                presentationLayout: PresentationLayout(
                    horizontalLayout: .fill,
                    verticalLayout: .automatic(alignment: .bottom)
                )
            )
        )

        let presented = UIViewController()
        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
            ) as? SheetPresentationController
        )

        let preferredContentSize = CGSize(width: 42, height: 42)

        presented.preferredContentSize = preferredContentSize

        let parentSize = CGSize(width: 1000, height: 1000)

        let containerView = UIView()
        containerView.frame.size = parentSize

        controller.setContainerView(containerView)

        let frame = controller.frameOfPresentedViewInContainerView

        XCTAssertEqual(
            frame.maxY,
            containerView.bounds.inset(
                by: controller.marginAdjustedEdgeInsets(
                    for: containerView.layoutMargins
                )
            ).maxY
        )
    }

    func testLayoutsAreIntegral() throws {
        let manager = SheetPresentationManager(
            options: SheetPresentationOptions(
                presentationLayout: PresentationLayout(
                    horizontalLayout: .automatic(alignment: .center),
                    verticalLayout: .automatic(alignment: .middle)
                )
            )
        )

        let presented = UIViewController()
        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
            ) as? SheetPresentationController
        )

        let preferredContentSize = CGSize(width: 42.5, height: 42.5)

        presented.preferredContentSize = preferredContentSize

        let parentSize = CGSize(width: 1000, height: 1000)

        let containerView = UIView()
        containerView.frame.size = parentSize

        controller.setContainerView(containerView)

        let frame = controller.frameOfPresentedViewInContainerView

        XCTAssertEqual(
            frame.size,
            CGSize(width: 44, height: 44)
        )
    }

    func testLayoutWhenThereIsNoContainerView() throws {
        let manager = SheetPresentationManager(
            options: SheetPresentationOptions(
                presentationLayout: PresentationLayout(
                    horizontalLayout: .automatic(alignment: .center),
                    verticalLayout: .automatic(alignment: .middle)
                )
            )
        )

        let presented = UIViewController()
        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
            ) as? SheetPresentationController
        )

        let preferredContentSize = CGSize(width: 42, height: 42)

        presented.preferredContentSize = preferredContentSize

        let frame = controller.frameOfPresentedViewInContainerView

        XCTAssertEqual(frame, .zero)
    }

    // MARK: - containerViewWillLayoutSubviews()

    func testContainerViewWillLayoutSubviewsCallsSuper() throws {
        let manager = SheetPresentationManager()

        let presented = MockViewController()
        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
            ) as? SheetPresentationController
        )

        let selector = #selector(
            SheetPresentationController.containerViewWillLayoutSubviews
        )

        let expect = expectationThatSuperIsCalled(object: controller,
                                                  selector: selector)

        controller.containerViewWillLayoutSubviews()

        wait(for: [expect], timeout: 2)
    }

    func testContainerViewWillLayoutSubviewsLaysOutDimmingView() throws {
        let options = SheetPresentationOptions(dimmingViewAlpha: 0.5)
        let manager = SheetPresentationManager(options: options)

        let presented = MockViewController()
        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
            ) as? SheetPresentationController
        )

        let containerView = UIView()
        containerView.frame.size = CGSize(width: 42, height: 42)
        controller.setContainerView(containerView)

        controller.containerViewWillLayoutSubviews()

        XCTAssertEqual(controller.dimmingView?.frame, containerView.bounds)
    }

    func testContainerViewWillLayoutSubviewsLaysOutPassthroughView() throws {
        let options = SheetPresentationOptions(dimmingViewAlpha: nil)
        let manager = SheetPresentationManager(options: options)

        let presented = MockViewController()
        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: source,
                source: source
            ) as? SheetPresentationController
        )

        let containerView = UIView()
        containerView.frame.size = CGSize(width: 42, height: 42)
        controller.setContainerView(containerView)

        controller.containerViewWillLayoutSubviews()

        XCTAssertEqual(controller.passthroughView?.frame, containerView.bounds)
    }

    //swiftlint:disable:next line_length
    func testContainerViewWillLayoutSubviewsAppliesRoundAllCornersCornerOptions() throws {
        let options = SheetPresentationOptions(
            cornerOptions: .roundAllCorners(radius: 8)
        )

        let manager = SheetPresentationManager(options: options)

        let presented = MockViewController()
        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
            ) as? SheetPresentationController
        )

        let containerView = UIView()
        containerView.frame.size = CGSize(width: 42, height: 42)
        controller.setContainerView(containerView)

        XCTAssertEqual(presented.view.layer.cornerRadius, 0)

        controller.containerViewWillLayoutSubviews()

        XCTAssertEqual(presented.view.layer.cornerRadius, 8)
        XCTAssertTrue(presented.view.clipsToBounds)

        if #available(iOS 11.0, macCatalyst 10.15, *) {
            XCTAssertEqual(presented.view.layer.maskedCorners, .all)
        }
    }

    //swiftlint:disable:next line_length
    func testContainerViewWillLayoutSubviewsAppliesRoundSomeCornersCornerOptions() throws {
        guard #available(iOS 11.0, macCatalyst 10.15, *) else {
            throw XCTSkip("Round Some Corners option not available")
        }

        let options = SheetPresentationOptions(
            cornerOptions: .roundSomeCorners(radius: 8, corners: [.bottom])
        )

        let manager = SheetPresentationManager(options: options)

        let presented = MockViewController()
        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
            ) as? SheetPresentationController
        )

        let containerView = UIView()
        containerView.frame.size = CGSize(width: 42, height: 42)
        controller.setContainerView(containerView)

        XCTAssertEqual(presented.view.layer.cornerRadius, 0)

        controller.containerViewWillLayoutSubviews()

        XCTAssertEqual(presented.view.layer.cornerRadius, 8)
        XCTAssertEqual(presented.view.layer.maskedCorners, .bottom)
        XCTAssertTrue(presented.view.clipsToBounds)
    }

    //swiftlint:disable:next line_length
    func testContainerViewWillLayoutSubviewsAppliesNoRoundedCornersCornerOptions() throws {
        let options = SheetPresentationOptions(cornerOptions: .none)
        let manager = SheetPresentationManager(options: options)

        let presented = MockViewController()
        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
            ) as? SheetPresentationController
        )

        let containerView = UIView()
        containerView.frame.size = CGSize(width: 42, height: 42)
        controller.setContainerView(containerView)

        XCTAssertEqual(presented.view.layer.cornerRadius, 0)

        controller.containerViewWillLayoutSubviews()

        XCTAssertEqual(presented.view.layer.cornerRadius, 0)
        XCTAssertFalse(presented.view.clipsToBounds)
    }

    // MARK: - presentationTransitionWillBegin()

    func testPresentationTransitionWillBeginCallsSuper() throws {
        let manager = SheetPresentationManager()

        let presented = MockViewController()
        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
            ) as? SheetPresentationController
        )

        let selector = #selector(
            SheetPresentationController.presentationTransitionWillBegin
        )

        let expect = expectationThatSuperIsCalled(object: controller,
                                                  selector: selector)

        controller.presentationTransitionWillBegin()

        wait(for: [expect], timeout: 2)
    }

    func testPresentationTransitionWillBeginLaysOutDimmingView() throws {
        let options = SheetPresentationOptions(dimmingViewAlpha: 0.5)
        let manager = SheetPresentationManager(options: options)

        let presented = MockViewController()
        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
            ) as? SheetPresentationController
        )

        let containerView = UIView()
        containerView.frame.size = CGSize(width: 42, height: 42)
        controller.setContainerView(containerView)

        controller.presentationTransitionWillBegin()

        XCTAssertEqual(controller.dimmingView?.frame, containerView.bounds)
    }

    func testPresentationTransitionWillBeginLaysOutPassthroughView() throws {
        let options = SheetPresentationOptions(dimmingViewAlpha: nil)
        let manager = SheetPresentationManager(options: options)

        let presented = MockViewController()
        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: source,
                source: source
            ) as? SheetPresentationController
        )

        let containerView = UIView()
        containerView.frame.size = CGSize(width: 42, height: 42)
        controller.setContainerView(containerView)

        controller.presentationTransitionWillBegin()

        XCTAssertEqual(controller.passthroughView?.frame, containerView.bounds)
    }

    func testPresentationTransitionWillBeginAnimatesDimmingView() throws {
        let options = SheetPresentationOptions(dimmingViewAlpha: 0.5)
        let manager = SheetPresentationManager(options: options)

        let coordinator = MockTransitionCoordinator()

        let presented = MockViewController()
        presented.transitionCoordinator = coordinator

        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
            ) as? SheetPresentationController
        )

        let containerView = UIView()
        containerView.frame.size = CGSize(width: 42, height: 42)
        controller.setContainerView(containerView)

        controller.presentationTransitionWillBegin()

        if #available(iOS 11.3, macCatalyst 10.15, *) {
            XCTAssertEqual(controller.dimmingView?.alpha, 0)
        }
        else {
            let animation = try XCTUnwrap(
                controller.dimmingView?.layer.animation(forKey: "opacity")
                    as? CABasicAnimation
            )

            XCTAssertEqual(animation.fromValue as? CGFloat, 0)
        }

        coordinator.animateAlongsideTransitionAnimation?(coordinator)

        XCTAssertEqual(controller.dimmingView?.alpha, 1)
    }

    // MARK: - dismissalTransitionWillBegin()

    func testDismissalTransitionWillBeginCallsSuper() throws {
        let manager = SheetPresentationManager()

        let presented = MockViewController()
        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
            ) as? SheetPresentationController
        )

        let selector = #selector(
            SheetPresentationController.dismissalTransitionWillBegin
        )

        let expect = expectationThatSuperIsCalled(object: controller,
                                                  selector: selector)

        controller.dismissalTransitionWillBegin()

        wait(for: [expect], timeout: 2)
    }

    func testDismissalTransitionWillBeginsAnimatesDimmingView() throws {
        let options = SheetPresentationOptions(dimmingViewAlpha: 0.5)
        let manager = SheetPresentationManager(options: options)

        let coordinator = MockTransitionCoordinator()

        let presented = MockViewController()
        presented.transitionCoordinator = coordinator

        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
            ) as? SheetPresentationController
        )

        let containerView = UIView()
        containerView.frame.size = CGSize(width: 42, height: 42)
        controller.setContainerView(containerView)

        controller.dismissalTransitionWillBegin()

        if #available(iOS 11.3, macCatalyst 10.15, *) {
            XCTAssertEqual(controller.dimmingView?.alpha, 1)
        }
        else {
            let animation = try XCTUnwrap(
                controller.dimmingView?.layer.animation(forKey: "opacity")
                    as? CABasicAnimation
            )

            XCTAssertEqual(animation.fromValue as? CGFloat, 1)
        }

        coordinator.animateAlongsideTransitionAnimation?(coordinator)

        XCTAssertEqual(controller.dimmingView?.alpha, 0)
    }

    // MARK: - shouldPresentInFullscreen

    func testShouldPresentInFullscreenIsAlwaysFalse() throws {
        let manager = SheetPresentationManager()
        let presented = MockViewController()
        let source = UIViewController()

        let controller = try XCTUnwrap(
            manager.presentationController(
                forPresented: presented,
                presenting: nil,
                source: source
            ) as? SheetPresentationController
        )

        XCTAssertFalse(controller.shouldPresentInFullscreen)
    }

}
