//
//  BrickGameServicing.swift
//  Server
//
//  Created by Alena Ivanova on 20.01.2026.
//

import GameCore

protocol BrickGameServicing: Sendable {
    func listGames() -> GameList
    func selectGame(gameId: Int) async throws
    func postAction(_ action: UserAction) async throws
    func getState() async throws -> GameState
}
