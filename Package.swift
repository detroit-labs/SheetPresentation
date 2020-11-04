// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "SheetPresentation",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v10)
    ],
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
    swiftLanguageVersions: [.v4, .v4_2, .v5]
)
