// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "BottomSheetPresentation",
    platforms: [.iOS(.v8)],
    products: [
        .library(name: "BottomSheetPresentation",
                 targets: ["BottomSheetPresentation"]),
        .library(name: "BottomSheetPresentationLegacySupport",
                 targets: ["BottomSheetPresentationLegacySupport"])
    ],
    targets: [
        .target(name: "BottomSheetPresentationLegacySupport",
                dependencies: []),
        .target(name: "BottomSheetPresentation",
                dependencies: ["BottomSheetPresentationLegacySupport"]),
        .testTarget(name: "BottomSheetPresentationTests",
                    dependencies: ["BottomSheetPresentation"])
    ],
    swiftLanguageVersions: [
        .version("4"),
        .version("4.2"),
        .version("5")
    ]
)
