//
//  RaceWorldTests.swift
//  BrickGame
//
//  Created by Alena Ivanova on 17.03.2026.
//

import XCTest
@testable import RaceSwiftLib

final class RaceWorldTests: XCTestCase {
    
    func testInitialWorldHasPlayerCar() {
        let world = RaceWorld()
        
        XCTAssertNotNil(world.player, "Игрок должен существовать")
        
        let expectedX = (GameConstants.Field.columns - CarShapes.size.w) / 2
        let expectedY = GameConstants.Field.rows - CarShapes.size.h - 1

        XCTAssertEqual(world.player.upLeftPosition.x, expectedX,
                      "Игрок должен быть по центру по X")
        XCTAssertEqual(world.player.upLeftPosition.y, expectedY,
                      "Игрок должен быть внизу поля")
    }
    
    func testInitialWorldHasNoEnemies() {
        let world = RaceWorld()
        
        XCTAssertTrue(world.enemies.isEmpty, "В начале игры не должно быть врагов")
    }
    
    func testClearWorld() {
        var world = RaceWorld()
        world.enemies = [
            Car(upLeftPosition: Coordinate(x: 1, y: 1), body: CarShapes.enemy)
        ]
        
        world.clear()
        
        XCTAssertTrue(world.enemies.isEmpty, "После очистки не должно быть врагов")
        
        let expectedX = (GameConstants.Field.columns - CarShapes.size.w) / 2
        let expectedY = GameConstants.Field.rows - CarShapes.size.h - 1
        
        XCTAssertEqual(world.player.upLeftPosition.x, expectedX,
                      "Игрок должен вернуться в начальную позицию по X")
        XCTAssertEqual(world.player.upLeftPosition.y, expectedY,
                      "Игрок должен вернуться в начальную позицию по Y")
    }
}
