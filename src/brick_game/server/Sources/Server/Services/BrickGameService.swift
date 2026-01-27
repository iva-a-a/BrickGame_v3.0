//
//  BrickGameService.swift
//  Server
//
//  Created by Alena Ivanova on 20.01.2026.
//

import GameCore

struct BrickGameService: BrickGameServicing {
    let store: BrickGameSessionStore

    func listGames() -> GameList {
        let games = AvailableGame.allCases.map { GameInfo(id: $0.rawValue, name: $0.name) }
        return GameList(games: games)
    }

    func selectGame(gameId: Int) async throws {
        guard let game = AvailableGame(rawValue: gameId) else {
            throw BrickGameError.gameNotFound(gameId)
        }

        let currentId = await store.currentId()
        if let currentId, currentId != gameId {
            throw BrickGameError.gameAlreadyRunning
        }

        let engine = try EngineFactory.make(game)
        await store.set(gameId: gameId, engine: engine)
    }

    func postAction(_ action: UserAction) async throws {
        try await store.postUserAction(action)
    }

    func getState() async throws -> GameState {
        return try await store.getGameState()
    }
}
