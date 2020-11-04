//
//  SuperExpectationInjection.swift
//  SheetPresentationTests
//
//  Created by Jeff Kelley on 9/3/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

import ObjectiveC
import XCTest

private class SelfCleaningExpectation: XCTestExpectation {
    let cleanup: () -> Void

    init(description expectationDescription: String,
         cleanup: @escaping () -> Void) {
        self.cleanup = cleanup
        super.init(description: expectationDescription)
    }

    deinit {
        cleanup()
    }
}

extension XCTestCase {

    private static let expectationQueue = DispatchQueue(
        label: "com.detroitlabs.SheetPresentation.SuperExpectationInjection",
        attributes: [.concurrent]
    )

    private static let expectations =
        NSMapTable<NSObject, NSDictionary>.weakToStrongObjects()

    private static let methodPrefix = "DLSP_temporary_method_"

    private static func add(expectation: XCTestExpectation,
                            forObject object: NSObject,
                            selector: Selector) {
        expectationQueue.async(flags: [.barrier]) {
            let newDict: NSDictionary

            if let dictionary = self.expectations.object(forKey: object) {
                let mutableDict: NSMutableDictionary = dictionary.mutableCopy()
                    as! NSMutableDictionary

                mutableDict[selector] = expectation
                newDict = NSDictionary(dictionary: mutableDict)
            }
            else {
                newDict = [selector: expectation] as NSDictionary
            }

            self.expectations.setObject(newDict, forKey: object)
        }
    }

    private static func expectation(forObject object: NSObject,
                                    selector: Selector) -> XCTestExpectation? {
        expectationQueue.sync {
            let dictionary = expectations.object(forKey: object)

            return dictionary?.object(forKey: selector) as? XCTestExpectation
        }
    }

    private static func insertExpectationFulfillment(
        on subclass: AnyClass,
        superclass: AnyClass,
        selector: Selector
    ) -> (() -> Void) {
        guard let resolvedMethod = class_getInstanceMethod(superclass, selector)
            else { fatalError() }

        let newSelector = Selector(
            Self.methodPrefix + NSStringFromSelector(selector)
        )

        let methodName = "\(NSStringFromClass(superclass)).\(selector)"

        let imp: @convention(block)(NSObject, Selector) -> Void = { obj, _ in
            print("Calling injected superclass method for \(methodName)")

            if let expectation = Self.expectation(forObject: obj,
                                                  selector: selector) {
                expectation.fulfill()
            }
        }

        class_addMethod(superclass,
                        newSelector,
                        imp_implementationWithBlock(imp),
                        method_getTypeEncoding(resolvedMethod))

        guard let newMethod = class_getInstanceMethod(superclass, newSelector)
            else { fatalError() }

        method_exchangeImplementations(resolvedMethod, newMethod)

        return { method_exchangeImplementations(newMethod, resolvedMethod) }
    }

    func expectationThatSuperIsCalled<T: NSObject>(
        object: T,
        selector: Selector
    ) -> XCTestExpectation {
        guard let subclass = object_getClass(object),
            let superclass = class_getSuperclass(subclass)
            else { fatalError() }

        let cleanup = Self.insertExpectationFulfillment(on: subclass,
                                                        superclass: superclass,
                                                        selector: selector)

        let newExpectation = SelfCleaningExpectation(
            description: "This method calls its superclass implementation",
            cleanup: cleanup
        )

        Self.add(expectation: newExpectation,
                 forObject: object,
                 selector: selector)

        return newExpectation
    }

}
