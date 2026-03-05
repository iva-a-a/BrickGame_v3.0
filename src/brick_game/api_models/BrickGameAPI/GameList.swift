//
//  GameList.swift
//  BrickGame
//
//  Created by Alena Ivanova on 19.01.2026.
//

import Foundation

public struct GameList: Codable, Sendable {
    public let games: [GameInfo]
    
    public init(games: [GameInfo]) {
        self.games = games
    }
}
