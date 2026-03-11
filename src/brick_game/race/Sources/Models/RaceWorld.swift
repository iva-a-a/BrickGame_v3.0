//
//  RaceWorld.swift
//  Race
//
//  Created by Alena Ivanova on 12.01.2026.
//

struct RaceWorld {
    var player: Car
    var enemies: [Car]

    init() {
        self.player = RaceWorld.initialPlayerCar()
        self.enemies = []
    }
    
    mutating func clear() {
        player = RaceWorld.initialPlayerCar()
        enemies.removeAll()
    }

    private static func initialPlayerCar() -> Car {
        let startX = (GameConstants.Field.columns - CarShapes.size.w) / 2
        let startY = GameConstants.Field.rows - CarShapes.size.h - 1
        
        return Car(
            upLeftPosition: Coordinate(x: startX, y: startY),
            body: CarShapes.player
        )
    }
}
