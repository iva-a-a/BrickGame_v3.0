//
//  MovePlayerTests.swift
//  BrickGame
//
//  Created by Alena Ivanova on 17.03.2026.
//

import XCTest
@testable import RaceSwiftLib

final class MovePlayerTests: XCTestCase {
    
    func testMovePlayerUpdatesWorldPlayer() {
        var world = RaceWorld()
        let initialPlayer = world.player
        let newPlayer = Car(upLeftPosition: Coordinate(x: 5, y: 5), body: CarShapes.player)
        
        RaceGameplay.movePlayer(world: &world, to: newPlayer)
        
        XCTAssertNotEqual(world.player, initialPlayer, "Игрок должен измениться")
        XCTAssertEqual(world.player, newPlayer, "Игрок должен быть обновлен до новой позиции")
    }
    
    func testMovePlayerWithSamePosition() {
        var world = RaceWorld()
        let samePlayer = world.player
        
        RaceGameplay.movePlayer(world: &world, to: samePlayer)
        
        XCTAssertEqual(world.player, samePlayer, "Игрок должен остаться тем же")
    }
}
