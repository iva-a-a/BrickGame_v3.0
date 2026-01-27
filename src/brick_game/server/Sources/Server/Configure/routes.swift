import Vapor

func routes(_ app: Application) throws {
    let store = BrickGameSessionStore()
    let service = BrickGameService(store: store)
    try app.register(collection: BrickGameController(service: service))
}
