//
//  BrickGameController.swift
//  Server
//
//  Created by Alena Ivanova on 20.01.2026.
//

import Vapor
import BrickGameAPI

struct BrickGameController: RouteCollection {
    let service: any BrickGameServicing

    func boot(routes: any RoutesBuilder) throws {
        let api = routes.grouped("api")
        api.get("games", use: getGames)
        api.post("games", ":gameId", use: selectGame)
        api.post("actions", use: postAction)
        api.get("state", use: getState)
    }

    // GET /api/games
    func getGames(req: Request) async throws -> GameList {
        await service.listGames()
    }

    // POST /api/games/{gameId}
    func selectGame(req: Request) async throws -> HTTPStatus {
        guard let idStr = req.parameters.get("gameId"),
              let id = Int(idStr) else {
            throw BrickGameError.internalFailure("Invalid gameId")
        }
        try await service.selectGame(id: id)
        return .ok
    }

    // POST /api/actions
    func postAction(req: Request) async throws -> HTTPStatus {
        let action = try req.content.decode(UserAction.self)
        try await service.performAction(action)
        return .ok
    }

    // GET /api/state
    func getState(req: Request) async throws -> GameState {
        try await service.currentState()
    }
}
