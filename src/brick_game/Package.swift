// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "BrickGame",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.115.0"),
        // 🔵 Non-blocking, event-driven networking for Swift. Used for custom executors
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
    ],
    targets: [
        
        .target(
            name: "GameCore",
            dependencies: [
                .target(name: "TetrisCLib"),
                .target(name: "SnakeCPPLib"),
                .target(name: "BrickGameAPI"),
                .target(name: "RaceSwiftLib")
            ],
            path: "server/Sources/GameCore",
            swiftSettings: swiftSettings
        ),
        
        .target(
            name: "BrickGameAPI",
            path: "api_models/BrickGameAPI",
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
            publicHeadersPath: "wrapper",
            cxxSettings: [
                .headerSearchPath("wrapper"),
                .headerSearchPath("."),
                .headerSearchPath(".."),
                .unsafeFlags(["-std=c++17"])
            ]
        ),
    
        .target(
            name: "RaceSwiftLib",
            dependencies: [
                .target(name: "TetrisCLib"),
            ],
            path: "race/Sources",
            swiftSettings: swiftSettings
        ),
        
        .target(
            name: "Client",
            dependencies: [
                .target(name: "BrickGameAPI")
            ],
            path: "client/Sources",
            swiftSettings: swiftSettings
        ),

        .executableTarget(
            name: "Server",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .target(name: "GameCore")
            ],
            path: "server/Sources/Server",
            swiftSettings: swiftSettings
        ),
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("ExistentialAny"),
] }
