// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "TFYSwiftEmptyDataSet",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "TFYSwiftEmptyDataSetKit",
            targets: ["TFYSwiftEmptyDataSetKit"]
        )
    ],
    targets: [
        .target(
            name: "TFYSwiftEmptyDataSetKit",
            path: "TFYSwiftEmptyDataSet/TFYSwiftEmptyDataSetKit"
        )
    ]
)
