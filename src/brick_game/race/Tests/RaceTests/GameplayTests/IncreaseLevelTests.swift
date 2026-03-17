//
//  IncreaseLevelTests.swift
//  BrickGame
//
//  Created by Alena Ivanova on 17.03.2026.
//

import XCTest
@testable import RaceSwiftLib

final class IncreaseLevelTests: XCTestCase {
    
    func testIncreaseLevelWhenScoreIncreases() {
        var level = 1
        let score = GameConstants.Gameplay.scoreToLevelUp * 2
        
        RaceGameplay.increaseLevel(score: score, level: &level)
        
        XCTAssertEqual(level, 3, "Уровень должен увеличиться пропорционально счету")
    }
    
    func testIncreaseLevelDoesNotExceedMaxLevel() {
        var level = 1
        let score = GameConstants.Gameplay.scoreToLevelUp * (GameConstants.Gameplay.maxLevel + 5)
        
        RaceGameplay.increaseLevel(score: score, level: &level)
        
        XCTAssertEqual(level, GameConstants.Gameplay.maxLevel, "Уровень не должен превышать максимальный")
    }
    
    func testIncreaseLevelWhenScoreBelowFirstLevel() {
        var level = 1
        let score = GameConstants.Gameplay.scoreToLevelUp - 1
        
        RaceGameplay.increaseLevel(score: score, level: &level)
        
        XCTAssertEqual(level, 1, "Уровень не должен увеличиться")
    }
    
    func testIncreaseLevelOnlyIncreasesNotDecreases() {
        var level = 5
        let score = 0
        
        RaceGameplay.increaseLevel(score: score, level: &level)
        
        XCTAssertEqual(level, 5, "Уровень не должен уменьшаться")
    }
}
