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
		),
	],
	dependencies: [],
	targets: [
		.target(
			name: "HTTP",
			dependencies: [],
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
