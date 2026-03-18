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
        print(webGuiDir)
        app.middleware.use(FileMiddleware(publicDirectory: webGuiDir))

        app.get { req async throws -> Response in
            let indexPath = URL(fileURLWithPath: webGuiDir, isDirectory: true)
                .appendingPathComponent("index.html")
                .path
            return try await req.fileio.asyncStreamFile(at: indexPath)
        }
    }

    private static func makeWebGuiDir(_ app: Application) -> String {
        let workingDir = URL(fileURLWithPath: app.directory.workingDirectory, isDirectory: true)
        let webGui = workingDir.appendingPathComponent("/web_gui", isDirectory: true)
        return webGui.path
    }
}
