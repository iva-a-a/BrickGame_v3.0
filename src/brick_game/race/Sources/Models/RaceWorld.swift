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
        self.player = Car(
            upLeftPosition:
                Coordinate(
                    x: (GameConstants.Field.columns - CarShapes.size.w) / 2,
                    y: GameConstants.Field.rows - CarShapes.size.h - 1
                ),
            body: CarShapes.player
        )
        self.enemies = []
    }
}
