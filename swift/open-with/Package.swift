// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "open-with",
  platforms: [.macOS(.v12)],
  dependencies: [
    .package(url: "https://github.com/raycast/raycast-extension-macro", from: "0.1.0"),
    .package(
      url: "https://github.com/apple/swift-collections.git",
      .upToNextMinor(from: "1.0.0")
    )
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .executableTarget(
      name: "open-with",
      dependencies: [
       .product(name: "RaycastExtensionMacro", package: "raycast-extension-macro"),
       .product(name: "Collections", package: "swift-collections")
      ]
    ),
  ]
)
