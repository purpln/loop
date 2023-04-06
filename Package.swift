// swift-tools-version:5.7

import PackageDescription

let product: Product
let dependency: Package.Dependency = .package(url: "https://github.com/purpln/platform.git", branch: "main")
let target: Target
let ctarget: Target

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
product = .library(name: "Loop", targets: ["Loop"])
target = .target(name: "Loop", dependencies: ["CApple", .product(name: "Platform", package: "platform")])
ctarget = .systemLibrary(name: "CApple")
#elseif os(Linux) || os(Android) || os(FreeBSD)
product = .library(name: "Loop", targets: ["Loop"])
target = .target(name: "Loop", dependencies: ["CLinux", .product(name: "Platform", package: "platform")])
ctarget = .systemLibrary(name: "CLinux")
#elseif os(Windows)
product = .library(name: "Loop", targets: ["Loop"])
target = .target(name: "Loop", dependencies: ["CWindows", .product(name: "Platform", package: "platform")])
ctarget = .systemLibrary(name: "CWindows")
#endif

let package = Package(name: "Loop", products: [product], dependencies: [dependency], targets: [target, ctarget])

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
package.platforms = [.macOS(.v13), .iOS(.v16), .watchOS(.v9), .tvOS(.v16)]
#endif
