//
//  BrickGameSessionStore.swift
//  Server
//
//  Created by Alena Ivanova on 20.01.2026.
//

import Vapor
import GameCore

actor BrickGameSessionStore {
    private var currentGameId: Int?
    private var engine: (any BrickGameEngine)?

    // Check if a different game is running
    func canStartGame(gameId: Int) -> Bool {
        if let currentGameId, currentGameId != gameId {
            return false
        }
        return true
    }

    // Start new game engine
    func set(gameId: Int, engine: any BrickGameEngine) {
        self.currentGameId = gameId
        self.engine = engine
    }

    func clear() {
        self.currentGameId = nil
        self.engine = nil
    }

    // Forward user action to the engine
    func postUserAction(_ action: UserAction) throws {
        guard let engine else {
            throw BrickGameError.noGameSelected
        }
        engine.userInput(actionId: action.actionId, hold: action.hold)
    }

    // Retrieve game state
    func getGameState() throws -> GameState {
        guard let engine else {
            throw BrickGameError.noGameSelected
        }
        return engine.getState()
    }

    // Helper for selectGame to check current gameId
    func currentId() -> Int? {
        currentGameId
    }
}
