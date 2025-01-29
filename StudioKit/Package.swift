// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "StudioKit",
	platforms: [
		.macOS(.v15),
		.iOS(.v13),
	],
	products: [
		.library(name: "StudioKit", targets: [
			"WelcomeFeature",
			"StudioKit",
		]),
	],
	dependencies: [
//		.package(url: "https://github.com/lancelotbronner/knightos-klib", branch: "main"),
//		.package(url: "https://github.com/lancelotbronner/knightos-kpack", branch: "main"),
	],
	targets: [
		.target(name: "CoreStudio"),

		.target(name: "WelcomeFeature", dependencies: ["CoreStudio"]),

		.target(name: "StudioKit", dependencies: ["CoreStudio"]),
	]
)
