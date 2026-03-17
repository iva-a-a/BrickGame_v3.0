//
//  ChangeHighScoreTests.swift
//  BrickGame
//
//  Created by Alena Ivanova on 17.03.2026.
//

import XCTest
@testable import RaceSwiftLib

final class ChangeHighScoreTests: XCTestCase {
    
    func testChangeHighScoreWhenScoreGreater() {
        var highScore = 50
        let score = 100
        
        RaceGameplay.changeHighScore(score: score, highScore: &highScore)
        
        XCTAssertEqual(highScore, score, "HighScore должен обновиться до большего значения")
    }
    
    func testChangeHighScoreWhenScoreLess() {
        var highScore = 100
        let score = 50
        
        RaceGameplay.changeHighScore(score: score, highScore: &highScore)
        
        XCTAssertEqual(highScore, 100, "HighScore не должен уменьшаться")
    }
    
    func testChangeHighScoreWhenScoreEqual() {
        var highScore = 100
        let score = 100
        
        RaceGameplay.changeHighScore(score: score, highScore: &highScore)
        
        XCTAssertEqual(highScore, 100, "HighScore должен остаться тем же")
    }
}
