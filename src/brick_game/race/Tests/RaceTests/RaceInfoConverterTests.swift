//
//  RaceInfoConverterTests.swift
//  BrickGame
//
//  Created by Alena Ivanova on 17.03.2026.
//

import XCTest
@testable import RaceSwiftLib
import TetrisCLib

final class RaceInfoConverterTests: XCTestCase {
        
    func testToGameInfoBasic() {
        let world = RaceWorld()
        let stats = RaceStats()
        let isGameOver = false
        
        let gameInfo = RaceInfoConverter.toGameInfo(world: world, stats: stats, isGameOver: isGameOver)
        
        XCTAssertNotNil(gameInfo.field, "Поле не должно быть nil")
        XCTAssertNotNil(gameInfo.next, "Следующая фигура не должна быть nil когда игра не окончена")
        XCTAssertEqual(gameInfo.score, 0, "Счет должен быть 0")
        XCTAssertEqual(gameInfo.high_score, 0, "Рекорд должен быть 0")
        XCTAssertEqual(gameInfo.level, 1, "Уровень должен быть 1")
        XCTAssertEqual(gameInfo.pause, 0, "Пауза должна быть выключена")
    }
    
    func testToGameInfoWithGameOver() {
        let world = RaceWorld()
        let stats = RaceStats()
        let isGameOver = true
        
        let gameInfo = RaceInfoConverter.toGameInfo(world: world, stats: stats, isGameOver: isGameOver)
        
        XCTAssertNotNil(gameInfo.field, "Поле не должно быть nil")
        XCTAssertNil(gameInfo.next, "Следующая фигура должна быть nil когда игра окончена")
    }
    
    func testToGameInfoWithStats() {
        let world = RaceWorld()
        var stats = RaceStats()
        stats.score = 150
        stats.highScore = 200
        stats.level = 3
        stats.pause = true
        
        let gameInfo = RaceInfoConverter.toGameInfo(world: world, stats: stats, isGameOver: false)
        
        XCTAssertEqual(gameInfo.score, 150, "Счет должен соответствовать")
        XCTAssertEqual(gameInfo.high_score, 200, "Рекорд должен соответствовать")
        XCTAssertEqual(gameInfo.level, 3, "Уровень должен соответствовать")
        XCTAssertEqual(gameInfo.pause, 1, "Пауза должна быть включена")
    }
    
    func testSpeedConversion() {
        let world = RaceWorld()
        var stats = RaceStats()
        
        let baseSpeedMs = GameConstants.Gameplay.baseSpeedMs
        let baseSpeedUI = 1000
        let multiplier = baseSpeedUI / baseSpeedMs
        
        let testSpeeds = [100, 250, 500, 750, 1000, 2000]
        
        for speed in testSpeeds {
            stats.displaySpeed = speed
            stats.speed = 9999
            let gameInfo = RaceInfoConverter.toGameInfo(
                world: world,
                stats: stats,
                isGameOver: false
            )
            let expectedUISpeed = speed * multiplier
            
            XCTAssertEqual(
                Int(gameInfo.speed),
                expectedUISpeed,
                "Для displaySpeed \(speed) UI скорость должна быть \(expectedUISpeed)"
            )
        }
    }
    
    func testSpeedConversionWithBaseSpeed() {
        let world = RaceWorld()
        var stats = RaceStats()
        stats.speed = GameConstants.Gameplay.baseSpeedMs
        
        let gameInfo = RaceInfoConverter.toGameInfo(world: world, stats: stats, isGameOver: false)
        
        XCTAssertEqual(Int(gameInfo.speed), 1000,
                      "Базовая скорость должна конвертироваться в 1000")
    }
        
    func testFieldContainsPlayerCar() {
        var world = RaceWorld()
        world.player = Car(
            upLeftPosition: Coordinate(x: 5, y: 10),
            body: CarShapes.player
        )
        
        let gameInfo = RaceInfoConverter.toGameInfo(world: world, stats: RaceStats(), isGameOver: false)
        
        XCTAssertTrue(checkIfCellContainsPlayer(gameInfo.field, player: world.player),
                     "Поле должно содержать машину игрока")
    }
    
    func testFieldContainsEnemyCars() {
        var world = RaceWorld()
        let enemy1 = Car(
            upLeftPosition: Coordinate(x: 2, y: 3),
            body: CarShapes.enemy
        )
        let enemy2 = Car(
            upLeftPosition: Coordinate(x: 7, y: 5),
            body: CarShapes.enemy
        )
        world.enemies = [enemy1, enemy2]
        
        let gameInfo = RaceInfoConverter.toGameInfo(world: world, stats: RaceStats(), isGameOver: false)
        
        for enemy in world.enemies {
            XCTAssertTrue(checkIfCellContainsEnemy(gameInfo.field, enemy: enemy),
                         "Поле должно содержать врага на позиции \(enemy.upLeftPosition)")
        }
    }
    
    func testFieldClearedBetweenCalls() {
        var world = RaceWorld()
        let player1 = Car(
            upLeftPosition: Coordinate(x: 5, y: 10),
            body: CarShapes.player
        )
        world.player = player1
        
        _ = RaceInfoConverter.toGameInfo(world: world, stats: RaceStats(), isGameOver: false)
        
        let player2 = Car(
            upLeftPosition: Coordinate(x: 3, y: 8),
            body: CarShapes.player
        )
        world.player = player2
        
        let gameInfo2 = RaceInfoConverter.toGameInfo(world: world, stats: RaceStats(), isGameOver: false)
        
        XCTAssertTrue(checkIfCellContainsPlayer(gameInfo2.field, player: player2),
                      "Второй вызов должен содержать игрока на (3,8)")
        
        XCTAssertFalse(checkIfCellContainsPlayer(gameInfo2.field, player: player1),
                       "Во втором вызове не должно быть игрока на позиции (5,10)")
    }

    func testCarPartiallyOutOfBounds() {
        var world = RaceWorld()
        world.player = Car(
            upLeftPosition: Coordinate(x: -1, y: -1),
            body: CarShapes.player
        )
        
        let gameInfo = RaceInfoConverter.toGameInfo(world: world, stats: RaceStats(), isGameOver: false)
        
        XCTAssertNotNil(gameInfo.field, "Поле не должно быть nil")
    }
    
    func testCarCompletelyOutOfBounds() {
        var world = RaceWorld()
        world.player = Car(
            upLeftPosition: Coordinate(x: -10, y: -10),
            body: CarShapes.player
        )
        
        let gameInfo = RaceInfoConverter.toGameInfo(world: world, stats: RaceStats(), isGameOver: false)
        
        for y in 0..<Int(ROWS_BOARD) {
            for x in 0..<Int(COL_BOARD) {
                let value = getFieldCell(gameInfo.field, x: x, y: y)
                XCTAssertEqual(value, 0, "Ячейка (\(x),\(y)) должна быть пустой")
            }
        }
    }
    
    func testEnemyCarAtBottomEdge() {
        var world = RaceWorld()
        let bottomY = Int(ROWS_BOARD) - 1
        world.enemies = [
            Car(
                upLeftPosition: Coordinate(x: 5, y: bottomY),
                body: CarShapes.enemy
            )
        ]
        
        let gameInfo = RaceInfoConverter.toGameInfo(world: world, stats: RaceStats(), isGameOver: false)
        
        XCTAssertTrue(checkIfCellContainsEnemy(gameInfo.field, enemy: world.enemies[0]),
                     "Враг на нижней границе должен отображаться")
    }
        
    func testNextBufferWhenGameNotOver() {
        let world = RaceWorld()
        
        let gameInfo = RaceInfoConverter.toGameInfo(world: world, stats: RaceStats(), isGameOver: false)
        
        XCTAssertNotNil(gameInfo.next, "next буфер должен существовать когда игра не окончена")
    }
    
    func testNextBufferWhenGameOver() {
        let world = RaceWorld()
        
        let gameInfo = RaceInfoConverter.toGameInfo(world: world, stats: RaceStats(), isGameOver: true)
        
        XCTAssertNil(gameInfo.next, "next буфер должен быть nil когда игра окончена")
    }
        
    func testFieldWithManyEnemies() {
        var world = RaceWorld()
        for i in 0..<20 {
            let enemy = Car(
                upLeftPosition: Coordinate(x: i % 10, y: i / 2),
                body: CarShapes.enemy
            )
            world.enemies.append(enemy)
        }
        
        let gameInfo = RaceInfoConverter.toGameInfo(world: world, stats: RaceStats(), isGameOver: false)
        
        for enemy in world.enemies {
            let cells = enemy.occupiedCells()
            for cell in cells {
                if cell.x >= 0 && cell.x < Int(COL_BOARD) && 
                   cell.y >= 0 && cell.y < Int(ROWS_BOARD) {
                    let value = getFieldCell(gameInfo.field, x: cell.x, y: cell.y)
                    XCTAssertEqual(value, 1, "Ячейка врага должна быть заполнена")
                }
            }
        }
    }
        
    func testPerformanceOfToGameInfo() {
        let world = RaceWorld()
        let stats = RaceStats()
        
        measure {
            for _ in 0..<100 {
                _ = RaceInfoConverter.toGameInfo(world: world, stats: stats, isGameOver: false)
            }
        }
    }
    
    func testPerformanceWithManyEnemies() {
        var world = RaceWorld()
        for i in 0..<50 {
            let enemy = Car(
                upLeftPosition: Coordinate(x: i % 10, y: i / 5),
                body: CarShapes.enemy
            )
            world.enemies.append(enemy)
        }
        let stats = RaceStats()
        
        measure {
            _ = RaceInfoConverter.toGameInfo(world: world, stats: stats, isGameOver: false)
        }
    }
        
    private func getFieldCell(_ field: UnsafeMutablePointer<UnsafeMutablePointer<Int32>?>?, 
                              x: Int, y: Int) -> Int32 {
        guard let field = field,
              y >= 0 && y < Int(ROWS_BOARD),
              x >= 0 && x < Int(COL_BOARD),
              let row = field[y] else {
            return -1
        }
        return row[x]
    }
    
    private func checkIfCellContainsPlayer(_ field: UnsafeMutablePointer<UnsafeMutablePointer<Int32>?>?,
                                           player: Car,
                                           expectedX: Int? = nil,
                                           expectedY: Int? = nil) -> Bool {
        let cells = player.occupiedCells()
        
        for cell in cells {
            let x = expectedX ?? cell.x
            let y = expectedY ?? cell.y
            
            if x >= 0 && x < Int(COL_BOARD) && y >= 0 && y < Int(ROWS_BOARD) {
                let value = getFieldCell(field, x: x, y: y)
                if value != 1 {
                    return false
                }
            }
        }
        return true
    }
    
    private func checkIfCellContainsEnemy(_ field: UnsafeMutablePointer<UnsafeMutablePointer<Int32>?>?,
                                          enemy: Car) -> Bool {
        let cells = enemy.occupiedCells()
        
        for cell in cells {
            if cell.x >= 0 && cell.x < Int(COL_BOARD) && 
               cell.y >= 0 && cell.y < Int(ROWS_BOARD) {
                let value = getFieldCell(field, x: cell.x, y: cell.y)
                if value != 1 {
                    return false
                }
            }
        }
        return true
    }
}

final class RaceInfoConverterBufferTests: XCTestCase {
    
    func testFieldBufferSize() {        
        let gameInfo = RaceInfoConverter.toGameInfo(world: RaceWorld(), stats: RaceStats(), isGameOver: false)
        
        for y in 0..<Int(ROWS_BOARD) {
            XCTAssertNotNil(gameInfo.field?[y], "Строка \(y) должна существовать")
            
            for x in 0..<Int(COL_BOARD) {
                let value = gameInfo.field?[y]?[x]
                XCTAssertNotNil(value, "Ячейка (\(x),\(y)) должна быть доступна")
            }
        }
    }
    
    func testNextBufferSize() {
        let expectedRows = Int(ROWS_FIGURE)
        let expectedCols = Int(COL_FIGURE)
        
        let gameInfo = RaceInfoConverter.toGameInfo(world: RaceWorld(), stats: RaceStats(), isGameOver: false)
        
        for y in 0..<expectedRows {
            XCTAssertNotNil(gameInfo.next?[y], "Строка next \(y) должна существовать")
            
            for x in 0..<expectedCols {
                let value = gameInfo.next?[y]?[x]
                XCTAssertNotNil(value, "Ячейка next (\(x),\(y)) должна быть доступна")
            }
        }
    }
}
