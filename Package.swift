// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "tailwind",
    platforms: [.macOS(.v14), .iOS(.v17), .tvOS(.v17)],
    products: [
        .executable(name: "App", targets: ["App"]),
    ],
    dependencies: [
        .package(url: "https://github.com/hummingbird-project/hummingbird.git", from: "2.0.0-beta.4"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.0"),
        // Mustache
        .package(url: "https://github.com/hummingbird-project/swift-mustache.git", from: "2.0.0-beta.1"),
        // TailwindCSS
        .package(url: "https://github.com/tuist/SwiftyTailwind.git", .upToNextMinor(from: "0.5.0"))
    ],
    targets: [
        .executableTarget(name: "App",
                          dependencies: [
                            .product(name: "ArgumentParser", package: "swift-argument-parser"),
                            .product(name: "Hummingbird", package: "hummingbird"),
                            // Mustache
                            .product(name: "Mustache", package: "swift-mustache"),
                            // Tailwind CSS
                            .product(name: "SwiftyTailwind", package: "SwiftyTailwind")
                          ],
                          path: "Sources/App",
                          swiftSettings: [
                            // Enable better optimizations when building in Release configuration. Despite the use of
                            // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                            // builds. See <https://github.com/swift-server/guides#building-for-production> for details.
                            .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
                          ]
                         ),
        .testTarget(name: "AppTests",
                    dependencies: [
                        .byName(name: "App"),
                        .product(name: "HummingbirdTesting", package: "hummingbird")
                    ],
                    path: "Tests/AppTests"
                   )
    ]
)
