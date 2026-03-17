//
//  NextEnemiesTests.swift
//  BrickGame
//
//  Created by Alena Ivanova on 17.03.2026.
//

import XCTest
@testable import RaceSwiftLib

final class NextEnemiesTests: XCTestCase {
    
    func testNextEnemiesMovesAllEnemiesDown() {
        var world = RaceWorld()
        let initialPositions = [
            Coordinate(x: 1, y: 1),
            Coordinate(x: 2, y: 2),
            Coordinate(x: 3, y: 3)
        ]
        world.enemies = initialPositions.map {
            Car(upLeftPosition: $0, body: CarShapes.enemy)
        }
        
        let nextEnemies = RaceGameplay.nextEnemies(for: world)
        
        for (index, enemy) in nextEnemies.enumerated() {
            XCTAssertEqual(enemy.upLeftPosition.x, initialPositions[index].x,
                          "X координата не должна измениться")
            XCTAssertEqual(enemy.upLeftPosition.y, initialPositions[index].y + 1,
                          "Y координата должна увеличиться на 1")
        }
    }
    
    func testNextEnemiesWithEmptyEnemies() {
        let world = RaceWorld()
        
        let nextEnemies = RaceGameplay.nextEnemies(for: world)
        
        XCTAssertTrue(nextEnemies.isEmpty, "Должен вернуть пустой массив")
    }
    
    func testNextEnemiesPreservesCarBody() {
        var world = RaceWorld()
        let enemy = Car(upLeftPosition: Coordinate(x: 5, y: 5), body: CarShapes.enemy)
        world.enemies = [enemy]
        
        let nextEnemies = RaceGameplay.nextEnemies(for: world)
        
        XCTAssertEqual(nextEnemies.first?.body, enemy.body,
                      "Форма машины должна сохраниться")
    }
}
