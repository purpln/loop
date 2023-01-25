// swift-tools-version:5.7

import PackageDescription

let product: Product
let target: Target
let ctarget: Target

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
product = .library(name: "Loop", targets: ["Loop"])
target = .target(name: "Loop", dependencies: ["CApple"])
ctarget = .systemLibrary(name: "CApple")
#elseif os(Linux) || os(Android) || os(FreeBSD)
product = .library(name: "Loop", targets: ["Loop"])
target = .target(name: "Loop", dependencies: ["CLinux"])
ctarget = .systemLibrary(name: "CLinux")
#elseif os(Windows)
product = .library(name: "Loop", targets: ["Loop"])
target = .target(name: "Loop", dependencies: ["CWindows"])
ctarget = .systemLibrary(name: "CWindows")
#endif

let package = Package(name: "Loop", products: [product], targets: [target, ctarget])

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
package.platforms = [.macOS(.v13), .iOS(.v16), .watchOS(.v9), .tvOS(.v16)]
#endif
