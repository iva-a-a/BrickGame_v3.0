//
//  ApiService.swift
//  BrickGame
//
//  Created by Alena Ivanova on 04.02.2026.
//

import Foundation
import BrickGameAPI

final class ApiService: ApiServicing {
    private let client: NetworkClient

    init(client: NetworkClient) {
        self.client = client
    }

    func listGames() async throws -> GameList {
        try await client.get(Endpoints.games)
    }

    func selectGame(id: Int) async throws {
        _ = try await client.post(Endpoints.game(id), as: EmptyResponse.self)
    }

    func sendAction(actionId: Int, hold: Bool) async throws {
        let body = UserAction(actionId: actionId, hold: hold)
        _ = try await client.post(Endpoints.actions, body: body, as: EmptyResponse.self)
    }

    func getState() async throws -> GameState {
        try await client.get(Endpoints.state)
    }
}
