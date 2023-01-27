// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HDWalletKit",
    platforms: [
        .iOS(.v14),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "HDWalletKit",
            targets: ["HDWalletKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.4.0"),
        .package(url: "https://github.com/Boilertalk/secp256k1.swift.git", from: "0.1.7"),
    ],
    targets: [
        .target(
            name: "HDWalletKit",
            dependencies: [
                "CryptoSwift",
                .product(name: "secp256k1", package: "secp256k1.swift")
            ],
            path: "HDWalletKit",
            sources: ["Core",
                      "Keystore",
                      "Mnemonic",
                      "Models",
                      "Wallet",]),
    ],
    swiftLanguageVersions: [.v5]
)
