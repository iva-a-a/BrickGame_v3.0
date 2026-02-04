import Vapor

func routes(_ app: Application) throws {
    let service = BrickGameService()
    try app.register(collection: BrickGameController(service: service))
}
