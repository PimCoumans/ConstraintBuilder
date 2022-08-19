// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "ConstraintBuilder",
	platforms: [
		.iOS(.v11),
		.tvOS(.v9),
		.macCatalyst(.v13),
		.macOS(.v10_11)
	],
	products: [
		// Products define the executables and libraries a package produces, and make them visible to other packages.
		.library(
			name: "ConstraintBuilder",
			targets: ["ConstraintBuilder"]),
	],
	dependencies: [],
	targets: [
		.target(
			name: "ConstraintBuilder",
			dependencies: []),
		.testTarget(
			name: "ConstraintBuilderTests",
			dependencies: ["ConstraintBuilder"]),
	]
)
