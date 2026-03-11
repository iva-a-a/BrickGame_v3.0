//
//  GameConstants.swift
//  Race
//
//  Created by Alena Ivanova on 13.01.2026.
//

import Foundation

enum GameConstants {
    enum Field {
        static let rows: Int = 20
        static let columns: Int = 10
    }
    
    enum Gameplay {
        static let maxLevel: Int = 10
        static let overtakePoints: Int = 1
        static let scoreToLevelUp: Int = 5

        static let maxSpawnAttempts: Int = 10
        static let minTopGapY: Int = 6
        static let minGapX: Int = 3
        
        static let baseSpeedMs: Int = 900
        static let minSpeedMs: Int = 200
        static let speedStepMs: Int = 80
    }
}
