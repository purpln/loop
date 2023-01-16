// swift-tools-version:5.7

import PackageDescription

let loop: [Target.Dependency]
#if os(macOS) || os(iOS)
loop = []
#elseif os(Linux)
loop = ["CEpoll"]
#endif

let package = Package(
    name: "Loop",
    products: [
        .library(name: "Loop", targets: ["Loop"])
    ],
    targets: [
        .target(name: "Loop", dependencies: loop)
    ]
)

#if os(macOS) || os(iOS)
package.platforms = [.macOS(.v13), .iOS(.v16)]
#elseif os(Linux)
package.targets.append(.systemLibrary(name: "CEpoll"))
#endif
