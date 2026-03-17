//
//  MoveEnemiesTests.swift
//  BrickGame
//
//  Created by Alena Ivanova on 17.03.2026.
//

import XCTest
@testable import RaceSwiftLib

final class MoveEnemiesTests: XCTestCase {
    
    func testMoveEnemiesUpdatesWorldEnemies() {
        var world = RaceWorld()
        var stats = RaceStats()
        let initialEnemies = world.enemies
        let newEnemies = [Car(upLeftPosition: Coordinate(x: 1, y: 1), body: CarShapes.enemy)]
        
        RaceGameplay.moveEnemies(world: &world, to: newEnemies, score: &stats.score)
        
        XCTAssertNotEqual(world.enemies, initialEnemies, "Враги должны измениться")
        XCTAssertEqual(world.enemies, newEnemies, "Враги должны быть обновлены")
    }
    
    func testMoveEnemiesRemovesOffScreenEnemies() {
        var world = RaceWorld()
        let offScreenY = GameConstants.Field.rows
        let onScreenY = GameConstants.Field.rows - 1
        let enemies = [
            Car(upLeftPosition: Coordinate(x: 1, y: offScreenY), body: CarShapes.enemy),
            Car(upLeftPosition: Coordinate(x: 2, y: onScreenY), body: CarShapes.enemy),
            Car(upLeftPosition: Coordinate(x: 3, y: offScreenY + 5), body: CarShapes.enemy)
        ]
        var score = 0
        
        RaceGameplay.moveEnemies(world: &world, to: enemies, score: &score)
        
        XCTAssertEqual(world.enemies.count, 1, "Должен остаться только один враг на экране")
        XCTAssertEqual(world.enemies.first?.upLeftPosition.y, onScreenY, "Оставшийся враг должен быть на экране")
    }
    
    func testMoveEnemiesIncreasesScoreForRemovedEnemies() {
        var world = RaceWorld()
        let enemies = [
            Car(upLeftPosition: Coordinate(x: 1, y: GameConstants.Field.rows), body: CarShapes.enemy),
            Car(upLeftPosition: Coordinate(x: 2, y: GameConstants.Field.rows + 2), body: CarShapes.enemy)
        ]
        var score = 0
        let expectedPoints = 2 * GameConstants.Gameplay.overtakePoints
        
        RaceGameplay.moveEnemies(world: &world, to: enemies, score: &score)
        
        XCTAssertEqual(score, expectedPoints, "Счет должен увеличиться на количество удаленных врагов * очки")
    }
    
    func testMoveEnemiesDoesNotIncreaseScoreWhenNoEnemiesRemoved() {
        var world = RaceWorld()
        let enemies = [
            Car(upLeftPosition: Coordinate(x: 1, y: 1), body: CarShapes.enemy),
            Car(upLeftPosition: Coordinate(x: 2, y: 2), body: CarShapes.enemy)
        ]
        var score = 10
        
        RaceGameplay.moveEnemies(world: &world, to: enemies, score: &score)
        
        XCTAssertEqual(score, 10, "Счет не должен измениться")
    }
}
