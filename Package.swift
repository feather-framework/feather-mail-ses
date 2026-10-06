// swift-tools-version:6.3
import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .swiftLanguageMode(.v6),
    .strictMemorySafety(),
    .treatAllWarnings(as: .error),
    .enableUpcomingFeature("InternalImportsByDefault"),
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableUpcomingFeature("InferIsolatedConformances"),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    .enableUpcomingFeature("ImmutableWeakCaptures"),
    .enableExperimentalFeature("SuppressedAssociatedTypes"),
    .enableExperimentalFeature("LifetimeDependence"),
    .enableExperimentalFeature("Lifetimes"),
    .enableUpcomingFeature("StrictConcurrency"),
]

let package = Package(
    name: "feather-mail-ses",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "FeatherMailSES", targets: ["FeatherMailSES"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log", from: "1.14.0"),
        // [docc-plugin-placeholder]
        .package(url: "https://github.com/soto-project/soto-core", from: "7.17.0"),
        .package(url: "https://github.com/feather-framework/feather-mail", exact: "1.0.0-rc.1"),
    ],
    targets: [
        .target(
            name: "FeatherSotoSES",
            dependencies: [
                .product(name: "SotoCore", package: "soto-core"),
            ],
            exclude: [
                "sesv2-2019-09-27.json",
                "soto.config.json",
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "FeatherMailSES",
            dependencies: [
                .product(name: "FeatherMail", package: "feather-mail"),
                .target(name: "FeatherSotoSES"),
                .product(name: "SotoCore", package: "soto-core"),
                .product(name: "Logging", package: "swift-log"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "FeatherMailSESTests",
            dependencies: [
                .product(name: "FeatherMail", package: "feather-mail"),
                .target(name: "FeatherMailSES"),
                .target(name: "FeatherSotoSES"),
            ],
            swiftSettings: swiftSettings
        ),
    ]
)
