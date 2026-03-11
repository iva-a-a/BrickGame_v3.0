//
//  RaceInfoConverter.swift
//  Race
//
//  Created by Alena Ivanova on 25.02.2026.
//

import Foundation
import TetrisCLib

enum RaceInfoConverter {
    
    private static let fieldCellCount = Int(ROWS_BOARD) * Int(COL_BOARD)
    private static let nextCellCount = Int(ROWS_FIGURE) * Int(COL_FIGURE)

    nonisolated(unsafe) private static let fieldBuffer: UnsafeMutablePointer<Int32> = {
        let ptr = UnsafeMutablePointer<Int32>.allocate(capacity: fieldCellCount)
        ptr.initialize(repeating: 0, count: fieldCellCount)
        return ptr
    }()

    nonisolated(unsafe) private static let fieldRows: UnsafeMutablePointer<UnsafeMutablePointer<Int32>?> = {
        let rows = UnsafeMutablePointer<UnsafeMutablePointer<Int32>?>.allocate(capacity: Int(ROWS_BOARD))
        for y in 0..<Int(ROWS_BOARD) {
            rows[y] = fieldBuffer.advanced(by: y * Int(COL_BOARD))
        }
        return rows
    }()

    nonisolated(unsafe) private static let nextBuffer: UnsafeMutablePointer<Int32> = {
        let ptr = UnsafeMutablePointer<Int32>.allocate(capacity: nextCellCount)
        ptr.initialize(repeating: 0, count: nextCellCount)
        return ptr
    }()

    nonisolated(unsafe) private static let nextRows: UnsafeMutablePointer<UnsafeMutablePointer<Int32>?> = {
        let rows = UnsafeMutablePointer<UnsafeMutablePointer<Int32>?>.allocate(capacity: Int(ROWS_FIGURE))
        for y in 0..<Int(ROWS_FIGURE) {
            rows[y] = nextBuffer.advanced(by: y * Int(COL_FIGURE))
        }
        return rows
    }()

    static func toGameInfo(world: RaceWorld, stats: RaceStats, isGameOver: Bool) -> GameInfo_t {
        clearBuffer(fieldBuffer, fieldCellCount)
        clearBuffer(nextBuffer, nextCellCount)

        fillFieldByCar(world.player)
        for enemy in world.enemies {
            fillFieldByCar(enemy)
        }

        var out = GameInfo_t()
        out.field = fieldRows
        out.next = isGameOver ? nil : nextRows
        out.score = CInt(stats.score)
        out.high_score = CInt(stats.highScore)
        out.level = CInt(stats.level)
        out.speed = CInt(stats.speed)
        out.pause = stats.pause ? 1 : 0

        return out
    }

    private static func clearBuffer(_ buffer: UnsafeMutablePointer<Int32>, _ cellCount: Int) {
        buffer.update(repeating: 0, count: cellCount)
    }

    private static func fillFieldByCar(_ car: Car) {
        for point in car.body {
            let x = car.upLeftPosition.x + point.x
            let y = car.upLeftPosition.y + point.y
            setFieldCell(x: x, y: y, rows: Int(ROWS_BOARD), cols: Int(COL_BOARD))
        }
    }

    private static func setFieldCell(x: Int, y: Int, rows: Int, cols: Int) {
        guard x >= 0, x < cols, y >= 0, y < rows else { return }
        fieldBuffer[y * cols + x] = 1
    }
}
