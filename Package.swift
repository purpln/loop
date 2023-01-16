// swift-tools-version:5.7

import PackageDescription

let loop: [Target.Dependency] = []
#if os(Linux)
loop = ["CEpoll"]
#endif

let package = Package(
    name: "Loop",
    products: [.library(name: "Loop", targets: ["Loop"])],
    targets: [
        .target(name: "Loop", dependencies: loop)
    ]
)

#if os(Linux)
package.targets.append(.systemLibrary(name: "CEpoll"))
#endif
