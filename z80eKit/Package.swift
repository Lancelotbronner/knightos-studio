// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "z80eKit",
    products: [
        .library(name: "z80eKit", targets: ["Z80", "eZ80"]),
    ],
	dependencies: [
		.package(path: "../../../../EmulationKit"),
	],
    targets: [
        .target(name: "Z80", dependencies: ["EmulationKit"]),
		.target(name: "eZ80", dependencies: ["EmulationKit"]),
    ]
)
