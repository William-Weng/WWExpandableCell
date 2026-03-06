// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWExpandableCell",
    platforms: [
        .iOS(.v15)
    ],
    products: [.library(name: "WWExpandableCell", targets: ["WWExpandableCell"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "WWExpandableCell", resources: [.copy("Privacy")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
