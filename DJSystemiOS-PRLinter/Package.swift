// swift-tools-version:5.3
import PackageDescription

let dangerDependencies = "DangerDependencies"

let package = Package(
    name: "DJSystemiOS-PRLinter",
    defaultLocalization: "ja",
    platforms: [.macOS(.v10_15)],
    // https://medium.com/kinandcartacreated/your-guide-to-danger-swift-on-ci-83e3f5136a9a
    products: [
      .library(name: "DangerDeps", type: .dynamic, targets: [dangerDependencies])
    ],
    dependencies: [
        .package(name: "danger-swift", url: "https://github.com/danger/swift.git", from: "3.0.0"),
        .package(name: "DangerSwiftKantoku", url: "https://www.github.com/yumemi-inc/danger-swift-kantoku.git", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: dangerDependencies,
            dependencies: [
                .product(name: "Danger", package: "danger-swift"),
                .product(name: "DangerSwiftKantoku", package: "DangerSwiftKantoku")
            ]
        )
    ]
)
