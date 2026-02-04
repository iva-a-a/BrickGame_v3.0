// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "Server",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.115.0"),
        // 🔵 Non-blocking, event-driven networking for Swift. Used for custom executors
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
        .package(path: "race/Race"),
    ],
    targets: [
        
        .target(
            name: "GameCore",
            dependencies: [
                .target(name: "TetrisCLib"),
                .target(name: "SnakeCPPLib"),
                .target(name: "BrickGameAPI")
            ],
            path: "server/Sources/GameCore",
            swiftSettings: swiftSettings
        ),
        
        .target(
            name: "BrickGameAPI",
            path: "api/BrickGameAPI",
            swiftSettings: swiftSettings
        ),
        
        .target(
            name: "TetrisCLib",
            path: "tetris",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),
        
        .target(
            name: "SnakeCPPLib",
            path: "snake",
            publicHeadersPath: "wrapper_for_swift",
            cxxSettings: [
                .headerSearchPath("wrapper_for_swift"),
                .headerSearchPath("."),
                .headerSearchPath(".."),
                .unsafeFlags(["-std=c++17"])
            ]
        ),

        .executableTarget(
            name: "Server",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "Race", package: "Race"),
                .target(name: "GameCore"),
                .target(name: "BrickGameAPI"),
                .target(name: "TetrisCLib"),
                .target(name: "SnakeCPPLib")
            ],
            path: "server/Sources/Server",
            swiftSettings: swiftSettings
        ),
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("ExistentialAny"),
] }
