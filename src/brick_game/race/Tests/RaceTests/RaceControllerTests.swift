//
//  RaceControllerTests.swift
//  BrickGame
//
//  Created by Alena Ivanova on 17.03.2026.
//

import XCTest
@testable import RaceSwiftLib

final class RaceControllerTests: XCTestCase {
    
    var controller: RaceController!
    
    override func setUp() {
        super.setUp()
        controller = RaceController()
    }
    
    override func tearDown() {
        controller = nil
        super.tearDown()
    }
        
    func testInitialState() {
        XCTAssertEqual(controller.state, .begin, "Начальное состояние должно быть .begin")
        XCTAssertFalse(controller.stats.pause, "В начале пауза не активна")
        XCTAssertEqual(controller.stats.score, 0, "Начальный счет должен быть 0")
        XCTAssertEqual(controller.stats.level, 1, "Начальный уровень должен быть 1")
    }
    
    func testUserInputStartFromBegin() {
        XCTAssertEqual(controller.state, .begin)
        
        controller.userInput(.start, hold: false)
        
        XCTAssertEqual(controller.state, .running, "Из .begin с .start должен перейти в .running")
    }
    
    func testUserInputPauseFromRunning() {
        controller.userInput(.start, hold: false)
        XCTAssertEqual(controller.state, .running)
        
        controller.userInput(.pause, hold: false)
        
        XCTAssertEqual(controller.state, .break, "Из .running с .pause должен перейти в .break")
    }
    
    func testUserInputPauseFromBreak() {
        controller.userInput(.start, hold: false)
        controller.userInput(.pause, hold: false)
        XCTAssertEqual(controller.state, .break)
        
        controller.userInput(.pause, hold: false)
        
        XCTAssertEqual(controller.state, .running, "Из .break с .pause должен перейти в .running")
    }
    
    func testUserInputTerminateFromRunning() {
        controller.userInput(.start, hold: false)
        controller.userInput(.terminate, hold: false)

        XCTAssertEqual(controller.state, .end, "Из .running с .terminate должен перейти в .end")
    }
    
    func testUserInputTerminateFromEnd() {
        controller.userInput(.start, hold: false)
        controller.userInput(.terminate, hold: false)
        XCTAssertEqual(controller.state, .end)
        
        controller.userInput(.terminate, hold: false)
        
        XCTAssertEqual(controller.state, .begin, "Из .end с .terminate должен перейти в .begin")
    }
    
    func testUserInputLeftFromRunning() {
        controller.userInput(.start, hold: false)
        let initialX = controller.world.player.upLeftPosition.x
        
        controller.userInput(.left, hold: false)
        
        XCTAssertEqual(controller.state, .movingLeft, "Должен перейти в .movingLeft")
        
        let (world, _) = controller.update()
        
        XCTAssertEqual(world.player.upLeftPosition.x, initialX - 1,
                      "Игрок должен сместиться влево")
        XCTAssertEqual(controller.state, .running, "После движения должен вернуться в .running")
    }
    
    func testUserInputRightFromRunning() {
        controller.userInput(.start, hold: false)
        let initialX = controller.world.player.upLeftPosition.x
        controller.userInput(.right, hold: false)
        
        XCTAssertEqual(controller.state, .movingRight, "Должен перейти в .movingRight")
        
        let (world, _) = controller.update()
        
        XCTAssertEqual(world.player.upLeftPosition.x, initialX + 1,
                      "Игрок должен сместиться вправо")
        XCTAssertEqual(controller.state, .running, "После движения должен вернуться в .running")
    }
    
    func testUserInputLeftAtBoundary() {
        controller.userInput(.start, hold: false)
        controller.world.player.upLeftPosition.x = 0
        controller.userInput(.left, hold: false)
        
        let (world, _) = controller.update()
        
        XCTAssertEqual(world.player.upLeftPosition.x, 0,
                      "Игрок не должен выйти за левую границу")
    }
        
    func testCollisionWhenMovingLeft() {
        controller.userInput(.start, hold: false)
        let enemyX = controller.world.player.upLeftPosition.x - 1
        let enemyY = controller.world.player.upLeftPosition.y
        controller.world.enemies = [
            Car(upLeftPosition: Coordinate(x: enemyX, y: enemyY), body: CarShapes.enemy)
        ]
        
        controller.userInput(.left, hold: false)
        let (_, _) = controller.update()
        
        XCTAssertEqual(controller.state, .end, "При коллизии игра должна закончиться")
    }
    
    func testCollisionWhenMovingRight() {
        controller.userInput(.start, hold: false)
        let enemyX = controller.world.player.upLeftPosition.x + 1
        let enemyY = controller.world.player.upLeftPosition.y
        controller.world.enemies = [
            Car(upLeftPosition: Coordinate(x: enemyX, y: enemyY), body: CarShapes.enemy)
        ]
        
        controller.userInput(.right, hold: false)
        let (_, _) = controller.update()
        
        XCTAssertEqual(controller.state, .end, "При коллизии игра должна закончиться")
    }

    func testUpdateInBeginState() {
        XCTAssertEqual(controller.state, .begin)
        
        let (world, stats) = controller.update()
        
        XCTAssertFalse(stats.pause, "В .begin пауза не должна быть активна")
        XCTAssertNotNil(world.player, "Мир должен существовать")
    }
    
    func testUpdateInBreakState() {
        controller.userInput(.start, hold: false)
        controller.userInput(.pause, hold: false)
        
        XCTAssertEqual(controller.state, .break)
    
        let (_, stats) = controller.update()
        
        XCTAssertTrue(stats.pause, "В .break пауза должна быть активна")
    }
    
    func testUpdateInEndState() {
        controller.userInput(.start, hold: false)
        controller.userInput(.terminate, hold: false)
        XCTAssertEqual(controller.state, .end)
        
        let (_, stats) = controller.update()
        
        let savedHighScore = HighScoreStorage.get()
        XCTAssertEqual(savedHighScore, stats.highScore, "Рекорд должен сохраниться")
    }
    
    func testSpeedIncreasesWithLevel() {
        controller.userInput(.start, hold: false)
        let initialSpeed = controller.stats.speed
        
        for i in 1...5 {
            controller.stats.score = i * GameConstants.Gameplay.scoreToLevelUp
            let _ = controller.update()
        }
        
        XCTAssertGreaterThan(controller.stats.level, 1, "Уровень должен повыситься")
        XCTAssertLessThan(controller.stats.speed, initialSpeed, 
                         "Скорость должна увеличиться (число мс должно уменьшиться)")
    }
    
    func testBoostSpeed() {
        controller.userInput(.start, hold: false)
        let normalSpeed = controller.stats.speed
        
        controller.userInput(.up, hold: true)
        let (_, boostedStats) = controller.update()
        
        XCTAssertLessThan(boostedStats.speed, normalSpeed,
                         "При бусте скорость должна быть выше (меньше мс)")
    }
    
    func testBoostDoesNotGoBelowMinSpeed() {
        controller.userInput(.start, hold: false)
        controller.stats.level = GameConstants.Gameplay.maxLevel
        let _ = controller.update()
        
        controller.userInput(.up, hold: true)
        let (_, stats) = controller.update()
        
        XCTAssertGreaterThanOrEqual(stats.speed, GameConstants.Gameplay.minSpeedMs,
                                   "Скорость не должна быть меньше минимальной")
    }

    func testRestartFromEndWithStart() {
        controller.userInput(.start, hold: false)
        controller.stats.score = 100
        controller.world.enemies = [Car(upLeftPosition: Coordinate(x: 5, y: 5), body: CarShapes.enemy)]
        controller.userInput(.terminate, hold: false)
        
        controller.userInput(.start, hold: false)
        
        XCTAssertEqual(controller.state, .running)
        XCTAssertEqual(controller.stats.score, 0, "Счет должен сброситься")
        XCTAssertTrue(controller.world.enemies.isEmpty, "Враги должны исчезнуть")
    }
    
    func testClearGameResetsAllProperties() {
        controller.userInput(.start, hold: false)
        controller.stats.score = 100
        controller.stats.level = 5
        controller.world.enemies = [Car(upLeftPosition: Coordinate(x: 5, y: 5), body: CarShapes.enemy)]
        
        controller.userInput(.terminate, hold: false)
        controller.userInput(.start, hold: false)
        
        XCTAssertEqual(controller.stats.score, 0)
        XCTAssertEqual(controller.stats.level, 1)
        XCTAssertTrue(controller.world.enemies.isEmpty)
        XCTAssertEqual(controller.stats.speed, GameConstants.Gameplay.baseSpeedMs)
    }

    func testHighScoreSavedOnGameEnd() {
        // Given
        let expectedHighScore = 250
        controller.userInput(.start, hold: false)
        controller.stats.score = expectedHighScore
        
        // When
        controller.userInput(.terminate, hold: false)
        let _ = controller.update() // Вызовет finishGame
        
        // Then
        let savedHighScore = HighScoreStorage.get()
        XCTAssertEqual(savedHighScore, expectedHighScore, "Рекорд должен сохраниться")
    }
    
    func testHighScoreLoadedOnStart() {
        let savedHighScore = 200
        HighScoreStorage.save(highScore: savedHighScore)
        
        let newController = RaceController()
        newController.userInput(.start, hold: false)
        
        XCTAssertEqual(newController.stats.highScore, savedHighScore,
                      "Рекорд должен загрузиться при старте")
    }
    
    
    func testCompleteGameSequence() {
        controller.userInput(.start, hold: false)
        XCTAssertEqual(controller.state, .running)
        
        controller.userInput(.left, hold: false)
        let (worldAfterLeft, _) = controller.update()
        let xAfterLeft = worldAfterLeft.player.upLeftPosition.x
        
        controller.userInput(.right, hold: false)
        let (worldAfterRight, _) = controller.update()
        let xAfterRight = worldAfterRight.player.upLeftPosition.x
        
        XCTAssertEqual(xAfterRight, xAfterLeft + 1, "После движения вправо должен вернуться")
        
        controller.userInput(.pause, hold: false)
        XCTAssertEqual(controller.state, .break)
        
        controller.userInput(.pause, hold: false)
        XCTAssertEqual(controller.state, .running)
        
        controller.userInput(.terminate, hold: false)
        XCTAssertEqual(controller.state, .end)
        
        controller.userInput(.start, hold: false)
        XCTAssertEqual(controller.state, .running)
        XCTAssertEqual(controller.stats.score, 0, "Счет должен сброситься")
    }
}

extension RaceControllerTests {
    
    func testPerformanceOfUpdate() {
        controller.userInput(.start, hold: false)
        
        measure {
            for _ in 0..<100 {
                _ = controller.update()
            }
        }
    }
    
    func testPerformanceWithManyEnemies() {
        controller.userInput(.start, hold: false)
        
        for i in 0..<50 {
            controller.world.enemies.append(
                Car(upLeftPosition: Coordinate(x: i % 10, y: i / 10), body: CarShapes.enemy)
            )
        }
        
        measure {
            for _ in 0..<50 {
                _ = controller.update()
            }
        }
    }
}

extension RaceControllerTests {
    
    func testUpdateWhenNoTimersInitialized() {
        controller.userInput(.start, hold: false)
        
        let (world, stats) = controller.update()
        
        XCTAssertNotNil(world)
        XCTAssertNotNil(stats)
    }
    
    func testMultipleUserInputsSameFrame() {
        controller.userInput(.start, hold: false)
        controller.userInput(.left, hold: false)
        controller.userInput(.right, hold: false)
        controller.userInput(.up, hold: true)
        
        let (_, _) = controller.update()
        XCTAssertEqual(controller.state, .running)
    }
}
