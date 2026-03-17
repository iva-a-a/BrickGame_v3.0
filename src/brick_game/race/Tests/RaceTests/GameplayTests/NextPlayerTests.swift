//
//  NextPlayerTests.swift
//  BrickGame
//
//  Created by Alena Ivanova on 17.03.2026.
//

import XCTest
@testable import RaceSwiftLib

final class NextPlayerTests: XCTestCase {
    
    func testNextPlayerLeftWhenPossible() {
        let world = RaceWorld()
        let initialX = world.player.upLeftPosition.x
        
        let nextPlayer = RaceGameplay.nextPlayer(for: world, action: .left)
        
        XCTAssertEqual(nextPlayer.upLeftPosition.x, initialX - 1,
                      "Должен сместиться влево на 1")
        XCTAssertEqual(nextPlayer.upLeftPosition.y, world.player.upLeftPosition.y,
                      "Y координата не должна измениться")
    }
    
    func testNextPlayerLeftAtLeftBoundary() {
        var world = RaceWorld()
        world.player.upLeftPosition.x = 0
        
        let nextPlayer = RaceGameplay.nextPlayer(for: world, action: .left)
        
        XCTAssertEqual(nextPlayer.upLeftPosition.x, 0,
                      "Не должен выходить за левую границу")
    }
    
    func testNextPlayerRightWhenPossible() {
        let world = RaceWorld()
        let initialX = world.player.upLeftPosition.x
        let maxX = GameConstants.Field.columns - CarShapes.size.w
        
        let nextPlayer = RaceGameplay.nextPlayer(for: world, action: .right)
        
        if initialX < maxX {
            XCTAssertEqual(nextPlayer.upLeftPosition.x, initialX + 1,
                          "Должен сместиться вправо на 1")
        }
    }
    
    func testNextPlayerRightAtRightBoundary() {
        var world = RaceWorld()
        let maxX = GameConstants.Field.columns - CarShapes.size.w
        world.player.upLeftPosition.x = maxX
        
        let nextPlayer = RaceGameplay.nextPlayer(for: world, action: .right)
        
        XCTAssertEqual(nextPlayer.upLeftPosition.x, maxX,
                      "Не должен выходить за правую границу")
    }
    
    func testNextPlayerWithOtherActions() {
        let world = RaceWorld()
        let originalPlayer = world.player
        let actions: [Action] = [.up, .down, .pause, .start, .none]
        
        for action in actions {
            let nextPlayer = RaceGameplay.nextPlayer(for: world, action: action)
            
            XCTAssertEqual(nextPlayer, originalPlayer,
                          "Действие \(action) не должно менять позицию игрока")
        }
    }
}
