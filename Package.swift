// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWExpandableCell",
    platforms: [
        .iOS(.v14)
    ],
    products: [.library(name: "WWExpandableCell", targets: ["WWExpandableCell"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "WWExpandableCell", dependencies: []),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
