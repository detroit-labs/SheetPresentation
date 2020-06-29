// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "SheetPresentation",
    platforms: [.iOS(.v11)],
    products: [
        .library(name: "SheetPresentation",
                 targets: ["SheetPresentation"])
    ],
    targets: [
        .target(name: "SheetPresentation",
                path: "Sources"),
        .testTarget(name: "SheetPresentationTests",
                    dependencies: ["SheetPresentation"],
                    path: "Tests")
    ],
    swiftLanguageVersions: [.version("5")]
)
