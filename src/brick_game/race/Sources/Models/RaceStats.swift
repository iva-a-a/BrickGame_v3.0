//
//  RaceStats.swift
//  Race
//
//  Created by Alena Ivanova on 25.02.2026.
//

struct RaceStats {
    var score: Int = 0
    var highScore: Int = 0
    var level: Int = 1
    var speed: Int = 1000
    var pause: Bool = false
    
    mutating func clear() {
        self.score = 0
        self.highScore = 0
        self.level = 1
        self.speed = 1000
        self.pause = false
    }
}
