//
//  GameList.swift
//  Server
//
//  Created by Alena Ivanova on 19.01.2026.
//

import Vapor

public struct GameList: Content {
    public let games: [GameInfo]
    
    public init(games: [GameInfo]) {
        self.games = games
    }
}
