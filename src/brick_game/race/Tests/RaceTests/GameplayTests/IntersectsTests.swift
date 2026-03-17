//
//  IntersectsTests.swift
//  BrickGame
//
//  Created by Alena Ivanova on 17.03.2026.
//

import XCTest
@testable import RaceSwiftLib

final class IntersectsTests: XCTestCase {
    
    func testIntersectsWhenPlayerAndEnemyOverlap() {
        let player = Car(upLeftPosition: Coordinate(x: 5, y: 5), body: CarShapes.player)
        let enemies = [
            Car(upLeftPosition: Coordinate(x: 5, y: 5), body: CarShapes.enemy)
        ]
        
        let result = RaceGameplay.intersects(player: player, enemies: enemies)
        
        XCTAssertTrue(result, "Должно быть пересечение, когда игрок и враг на одной позиции")
    }
    
    func testIntersectsWhenPlayerAndEnemyAdjacent() {
        let player = Car(upLeftPosition: Coordinate(x: 5, y: 5), body: CarShapes.player)
        let enemies = [
            Car(upLeftPosition: Coordinate(x: 6, y: 5), body: CarShapes.enemy)
        ]
        
        let result = RaceGameplay.intersects(player: player, enemies: enemies)
        let playerCells = Set(player.occupiedCells())
        let enemyCells = Set(enemies.flatMap { $0.occupiedCells() })
        let expectedResult = !playerCells.isDisjoint(with: enemyCells)
        
        XCTAssertEqual(result, expectedResult, "Результат должен соответствовать реальному перекрытию форм")
    }
    
    func testIntersectsWhenNoOverlap() {
        let player = Car(upLeftPosition: Coordinate(x: 5, y: 5), body: CarShapes.player)
        let enemies = [
            Car(upLeftPosition: Coordinate(x: 10, y: 10), body: CarShapes.enemy),
            Car(upLeftPosition: Coordinate(x: 0, y: 0), body: CarShapes.enemy)
        ]
        
        let result = RaceGameplay.intersects(player: player, enemies: enemies)
        
        XCTAssertFalse(result, "Не должно быть пересечения, когда объекты далеко")
    }
    
    func testIntersectsWithMultipleEnemies() {
        let player = Car(upLeftPosition: Coordinate(x: 5, y: 5), body: CarShapes.player)
        let enemies = [
            Car(upLeftPosition: Coordinate(x: 0, y: 0), body: CarShapes.enemy),
            Car(upLeftPosition: Coordinate(x: 5, y: 5), body: CarShapes.enemy),
            Car(upLeftPosition: Coordinate(x: 10, y: 10), body: CarShapes.enemy)
        ]
        
        let result = RaceGameplay.intersects(player: player, enemies: enemies)
        
        XCTAssertTrue(result, "Должно быть пересечение, если хотя бы один враг пересекается")
    }
}
