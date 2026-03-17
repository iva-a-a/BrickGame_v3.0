//
//  UpdateSpeedTests.swift
//  BrickGame
//
//  Created by Alena Ivanova on 17.03.2026.
//

import XCTest
@testable import RaceSwiftLib

final class UpdateSpeedTests: XCTestCase {
    
    func testUpdateSpeedWithBaseLevel() {
        var speed = 0
        let level = 1
        
        RaceGameplay.updateSpeed(level: level, speed: &speed)
        
        XCTAssertEqual(speed, GameConstants.Gameplay.baseSpeedMs,
                      "Скорость должна быть базовой для 1 уровня")
    }
    
    func testUpdateSpeedWithHigherLevel() {
        var speed = 0
        let level = 3
        let expectedSpeed = max(
            GameConstants.Gameplay.minSpeedMs,
            GameConstants.Gameplay.baseSpeedMs - (level - 1) * GameConstants.Gameplay.speedStepMs
        )
        
        RaceGameplay.updateSpeed(level: level, speed: &speed)
        
        XCTAssertEqual(speed, expectedSpeed, "Скорость должна уменьшаться с уровнем")
    }
    
    func testUpdateSpeedDoesNotGoBelowMinSpeed() {
        var speed = 0
        let veryHighLevel = 100
        let expectedSpeed = GameConstants.Gameplay.minSpeedMs
        
        RaceGameplay.updateSpeed(level: veryHighLevel, speed: &speed)
        
        XCTAssertEqual(speed, expectedSpeed, "Скорость не должна быть меньше минимальной")
    }
}
