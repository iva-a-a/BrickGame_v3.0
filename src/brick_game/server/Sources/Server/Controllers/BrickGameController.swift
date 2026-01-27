//
//  BrickGameController.swift
//  Server
//
//  Created by Alena Ivanova on 20.01.2026.
//

import Vapor
import GameCore

struct BrickGameController: RouteCollection {
    let service: any BrickGameServicing

    func boot(routes: any RoutesBuilder) throws {
        let api = routes.grouped("api")

        api.get("games", use: getGames)
        api.post("games", ":gameId", use: selectGame)
        api.post("actions", use: postAction)
        api.get("state", use: getState)
    }

    func getGames(req: Request) async throws -> GameList {
        service.listGames()
    }

    func selectGame(req: Request) async throws -> HTTPStatus {
        guard let idStr = req.parameters.get("gameId"),
              let id = Int(idStr) else {
            throw BrickGameError.invalidAction("Некорректный параметр gameId")
        }

        try await service.selectGame(gameId: id)
        return .ok
    }

    func postAction(req: Request) async throws -> HTTPStatus {
        let action = try req.content.decode(UserAction.self)
        try await service.postAction(action)
        return .ok
    }

    func getState(req: Request) async throws -> GameState {
        try await service.getState()
    }
}
