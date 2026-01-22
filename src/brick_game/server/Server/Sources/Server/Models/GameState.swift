//
//  GameState.swift
//  Server
//
//  Created by Alena Ivanova on 19.01.2026.
//

import Vapor

struct GameState: Content {
    let field: [[Bool]]
    let next: [[Bool]]
    let score: Int
    let highScore: Int
    let level: Int
    let speed: Int
    let pause: Bool
    
    enum CodingKeys: String, CodingKey {
        case field, next, score
        case highScore = "high_score"
        case level, speed, pause
    }
}
