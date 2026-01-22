//
//  GameConstants.swift
//  Race
//
//  Created by Alena Ivanova on 13.01.2026.
//

enum GameConstants {
    enum Car {
        static let height: Int = 4
        static let width: Int = 3
        
        static let minLane: Int = 1
        static let maxLane: Int = 3
        
        static let startLane: Int = 2
        static let startTopY: Int = 16 // можно поменять
        
        static let laneX = [0, 3, 6]
    }
    
    enum Field {
        static let rows: Int = 20
        static let columns: Int = 10
    }
    
    enum Gameplay {
      static let maxLevel: Int = 10
      static let overtakePoints: Int = 1
      static let scoreToLevelUp: Int = 5

      static let sameLaneMinGap: Int = 2
      static let diffLaneMinGap: Int = 4

      // Спавн: каждые 5...7 тиков
      static let spawnEveryMinTicks: Int = 5
      static let spawnEveryMaxTicks: Int = 7

      // Скорость движения соперников
      static let normalStep: Int = 1
      static let boostedStep: Int = 2
    }
}
