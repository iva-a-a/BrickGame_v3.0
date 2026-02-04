//
//  GameState.swift
//  Server
//
//  Created by Alena Ivanova on 19.01.2026.
//

import Foundation

public struct GameState: Codable, Sendable {
    public let field: [[Bool]]
    public let next: [[Bool]]
    public let score: Int
    public let highScore: Int
    public let level: Int
    public let speed: Int
    public let pause: Bool

    public init(
        field: [[Bool]],
        next: [[Bool]],
        score: Int,
        highScore: Int,
        level: Int,
        speed: Int,
        pause: Bool
    ) {
        self.field = field
        self.next = next
        self.score = score
        self.highScore = highScore
        self.level = level
        self.speed = speed
        self.pause = pause
    }
    
    public enum CodingKeys: String, CodingKey {
        case field, next, score
        case highScore = "high_score"
        case level, speed, pause
    }
}

