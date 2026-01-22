//
//  StaticFilesConfigurator.swift
//  Server
//
//  Created by Alena Ivanova on 22.01.2026.
//


import Vapor
import Foundation

enum StaticFilesConfigurator {

    static func configure(_ app: Application) throws {
        let webGuiDir = makeWebGuiDir(app)

        app.middleware.use(FileMiddleware(publicDirectory: webGuiDir))

        app.get { req async throws -> Response in
            let indexPath = URL(fileURLWithPath: webGuiDir, isDirectory: true)
                .appendingPathComponent("index.html")
                .path
            return try await req.fileio.asyncStreamFile(at: indexPath)
        }
    }

    private static func makeWebGuiDir(_ app: Application) -> String {
        if let root = Environment.get("BRICKGAME_ROOT") {
            return URL(fileURLWithPath: root, isDirectory: true)
                .appendingPathComponent("web_gui", isDirectory: true)
                .standardizedFileURL.path
        }

        let root = URL(fileURLWithPath: app.directory.workingDirectory, isDirectory: true)
            .appendingPathComponent("../..", isDirectory: true)
            .standardizedFileURL

        return root
            .appendingPathComponent("web_gui", isDirectory: true)
            .standardizedFileURL.path
    }
}
