// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "NavTime",
	platforms: [
		.iOS(.v17),
		.macOS(.v14),
		.watchOS(.v11),
		.tvOS(.v17),
		.visionOS(.v1),
	],
	products: [
		.library(
			name: "NavTime",
			targets: ["NavTime"]
		)
	],
	targets: [
		.target(
			name: "NavTime"
		),
		.testTarget(
			name: "NavTimeTests",
			dependencies: ["NavTime"]
		),
	]
)
