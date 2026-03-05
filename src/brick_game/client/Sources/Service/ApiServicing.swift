//
//  ApiServicing.swift
//  BrickGame
//
//  Created by Alena Ivanova on 04.02.2026.
//

import Foundation
import BrickGameAPI

public protocol ApiServicing: Sendable {
    func listGames() async throws -> GameList
    func selectGame(id: Int) async throws
    func sendAction(actionId: Int, hold: Bool) async throws
    func getState() async throws -> GameState
}
