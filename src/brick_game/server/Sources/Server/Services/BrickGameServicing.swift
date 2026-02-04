//
//  BrickGameServicing.swift
//  Server
//
//  Created by Alena Ivanova on 20.01.2026.
//

import GameCore
import Vapor
import BrickGameAPI

protocol BrickGameServicing: Sendable {
    func listGames() async -> GameList
    func selectGame(id: Int) async throws
    func performAction(_ action: UserAction) async throws
    func currentState() async throws -> GameState
}
