import Vapor
import Foundation

public func configure(_ app: Application) async throws {
    app.middleware.use(JSONErrorMiddleware())

    try StaticFilesConfigurator.configure(app)

    try routes(app)
}
