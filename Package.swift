// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

struct RemotePackage {
    let name: String
    let productName: String
    let url: String
    
    init(
        name: String,
        productName: String? = nil,
        url: String
    ) {
        self.name = name
        self.productName = productName ?? name
        self.url = url
    }
}

private let lsUIKit = "LSUIKit"
private let lsUIKitTests = "LSUIKitTests"

private let foundation = RemotePackage(
    name: "LSFoundation",
    url: "https://github.com/LudvigShtirner/LSFoundation.git"
)
private let snapKit = RemotePackage(
    name: "SnapKit",
    url: "https://github.com/SnapKit/SnapKit.git"
)

let package = Package(
    name: lsUIKit,
    platforms: [.iOS(
        .v15
    )],
    products: [
        .library(
            name: lsUIKit,
            targets: [lsUIKit]
        ),
    ],
    dependencies: [
        .package(
            url: foundation.url,
            .upToNextMajor(
                from: "0.1.0"
            )
        ),
        .package(
            url: snapKit.url,
            .upToNextMajor(
                from: "5.0.1"
            )
        )
    ],
    targets: [
        .target(
            name: lsUIKit,
            dependencies: [
                .byName(
                    name: foundation.name
                ),
                .byName(
                    name: snapKit.name
                )
            ]
        ),
        .testTarget(
            name: lsUIKitTests,
            dependencies: [
                .byName(
                    name: lsUIKit
                )
            ]
        ),
    ]
)
