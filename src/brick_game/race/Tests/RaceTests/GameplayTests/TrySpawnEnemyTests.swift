//
//  TrySpawnEnemyTests.swift
//  BrickGame
//
//  Created by Alena Ivanova on 17.03.2026.
//

import XCTest
@testable import RaceSwiftLib

final class TrySpawnEnemyTests: XCTestCase {
    
    func testTrySpawnEnemyWhenNoEnemies() {
        var world = RaceWorld()
        world.enemies = []
        let initialCount = world.enemies.count
        
        RaceGameplay.trySpawnEnemy(world: &world)
        
        XCTAssertEqual(world.enemies.count, initialCount + 1, "Должен появиться новый враг")
    }
    
    func testTrySpawnEnemyWhenEnemiesTooHigh() {
        var world = RaceWorld()
        world.enemies = [
            Car(upLeftPosition: Coordinate(x: 5, y: 1), body: CarShapes.enemy)
        ]
        
        RaceGameplay.trySpawnEnemy(world: &world)
        
        XCTAssertEqual(world.enemies.count, 1, "Не должен появляться новый враг, если существующие слишком высоко")
    }
    
    func testTrySpawnEnemyWhenEnemyNearTop() {
        var world = RaceWorld()
        world.enemies = [
            Car(upLeftPosition: Coordinate(x: 5, y: GameConstants.Gameplay.minTopGapY), body: CarShapes.enemy)
        ]
        
        RaceGameplay.trySpawnEnemy(world: &world)
        
        XCTAssertEqual(world.enemies.count, 1, "Не должен появляться новый враг на границе minTopGapY")
    }
    
    func testTrySpawnEnemyAvoidsOverlap() {
        var world = RaceWorld()
        for x in 0..<GameConstants.Field.columns {
            world.enemies.append(
                Car(upLeftPosition: Coordinate(x: x, y: 0), body: CarShapes.enemy)
            )
        }

        RaceGameplay.trySpawnEnemy(world: &world)
        
        XCTAssertEqual(world.enemies.count, GameConstants.Field.columns,
                      "Не должен спавниться враг из-за перекрытия")
    }
}
