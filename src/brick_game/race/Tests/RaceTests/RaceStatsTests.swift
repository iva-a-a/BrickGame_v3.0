//
//  RaceStatsTests.swift
//  BrickGame
//
//  Created by Alena Ivanova on 17.03.2026.
//

import XCTest
@testable import RaceSwiftLib

final class RaceStatsTests: XCTestCase {
    
    func testInitialStats() {
        let stats = RaceStats()
        
        XCTAssertEqual(stats.score, 0, "Начальный счет должен быть 0")
        XCTAssertEqual(stats.highScore, 0, "Начальный рекорд должен быть 0")
        XCTAssertEqual(stats.level, 1, "Начальный уровень должен быть 1")
        XCTAssertEqual(stats.speed, 500, "Начальная скорость должна быть 500")
        XCTAssertFalse(stats.pause, "Игра не должна быть на паузе")
    }
    
    func testClearStats() {
        var stats = RaceStats()
        stats.score = 100
        stats.highScore = 200
        stats.level = 5
        stats.speed = 1000
        stats.pause = true
        
        stats.clear()
        
        XCTAssertEqual(stats.score, 0, "Счет должен сброситься")
        XCTAssertEqual(stats.highScore, 0, "Рекорд должен сброситься")
        XCTAssertEqual(stats.level, 1, "Уровень должен сброситься до 1")
        XCTAssertEqual(stats.speed, 500, "Скорость должна сброситься")
        XCTAssertFalse(stats.pause, "Пауза должна сняться")
    }
}
