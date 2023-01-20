// swift-tools-version: 5.4

import PackageDescription

let package = Package(
  name: "swift-http",
  defaultLocalization: .init(rawValue: "en"),
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(
      name: "HTTP",
      targets: ["HTTP"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/JacksonUtsch/URLSessionBackport.git", .upToNextMajor(from: "0.2.1")),
  ],
  targets: [
    .target(
      name: "HTTP",
      dependencies: [
        .product(name: "URLSessionBackport", package: "URLSessionBackport")
      ],
      resources: [.process("Resources")]
    ),
    .testTarget(
      name: "HTTPTests",
      dependencies: ["HTTP"]
    ),
    .testTarget(
      name: "Examples",
      dependencies: ["HTTP"]
    ),
  ]
)
