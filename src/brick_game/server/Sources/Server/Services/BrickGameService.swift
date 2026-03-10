//
//  BrickGameService.swift
//  Server
//
//  Created by Alena Ivanova on 20.01.2026.
//

import Vapor
import GameCore
import BrickGameAPI

actor BrickGameService: BrickGameServicing {
    private var selectedGame: AvailableGame?
    private var engine: (any BrickGameEngine)?

    func listGames() async throws -> GameList {
        GameList(games: AvailableGame.allCases.map { GameInfo(id: $0.rawValue, name: $0.name) })
    }
    
    func selectGame(id: Int) async throws {
        guard let game = AvailableGame(rawValue: id) else {
            throw BrickGameError.gameNotFound(id)
        }
        engine = EngineFactory.make(game)
        selectedGame = game
    }

    func performAction(_ action: UserAction) async throws {
        guard let engine else { throw BrickGameError.noGameSelected }
        guard (10...18).contains(action.actionId) else {
            throw BrickGameError.invalidAction("Unknown action_id=\(action.actionId)")
        }

        engine.userInput(actionId: action.actionId, hold: action.hold)
    }

    func currentState() async throws -> GameState {
        guard let engine else { throw BrickGameError.noGameSelected }
        return engine.getState()
    }
}
