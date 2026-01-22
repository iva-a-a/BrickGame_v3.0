//
//  GameList.swift
//  Server
//
//  Created by Alena Ivanova on 19.01.2026.
//

import Vapor

struct GameList: Content {
    let games: [GameInfo]
}
