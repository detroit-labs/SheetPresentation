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
    swiftLanguageVersions: [.version("4"), .version("4.2"), .version("5")]
)
