// swift-tools-version: 6.1
//
//  Package.swift
//  SwiftMath
//
//  Created by Elvis on 11/07/2025.
//

import PackageDescription

let package = Package(
    name: "SwiftMath",
    products: [
        .library(name: "SwiftMath", targets: ["SwiftMath"])
    ],
    targets: [
        .target(name: "SwiftMath"),
        .testTarget(name: "SwiftMathTests", dependencies: ["SwiftMath"])
    ]
)
