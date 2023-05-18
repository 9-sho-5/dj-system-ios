// swift-tools-version:5.3
import PackageDescription

let dangerDependencies = "DangerDependencies"

let package = Package(
    name: "DJSystemiOS-PRLinter",
    defaultLocalization: "ja",
    platforms: [.macOS(.v10_15)],
    // Our Package.swift differs from Danger’s getting started documentation to enable builds on M1 machines. You may notice we’ve added a defaultLocalization to our Package, and used a .dynamic library to get Danger to build successfully (at the time of writing).
    // https://medium.com/kinandcartacreated/your-guide-to-danger-swift-on-ci-83e3f5136a9a
    products: [
      .library(name: "DangerDeps", type: .dynamic, targets: [dangerDependencies])
    ],
    dependencies: [
        .package(name: "danger-swift", url: "https://github.com/danger/swift.git", from: "3.0.0"),
        .package(name: "DangerXcodeSummary", url: "https://github.com/f-meloni/danger-swift-xcodesummary", from: "1.0.0")
    ],
    targets: [
        .target(
            name: dangerDependencies,
            dependencies: [
                .product(name: "Danger", package: "danger-swift"),
                .product(name: "DangerXCodeSummary", package: "DangerXcodeSummary")
            ]
        )
    ]
)
