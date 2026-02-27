//
//  RaceInfoConverter.swift
//  Race
//
//  Created by Alena Ivanova on 25.02.2026.
//

import Foundation
import TetrisCLib

final class RaceInfoConverter {

    private let rows: Int
    private let cols: Int

    private let fieldStorage: UnsafeMutablePointer<CInt>
    private let fieldRows: UnsafeMutablePointer<UnsafeMutablePointer<CInt>?>

    init(rows: Int = GameConstants.Field.rows,
         cols: Int = GameConstants.Field.columns) {
        self.rows = rows
        self.cols = cols
        fieldStorage = .allocate(capacity: rows * cols)
        fieldStorage.initialize(repeating: 0, count: rows * cols)

        fieldRows = .allocate(capacity: rows)
        for y in 0..<rows {
            fieldRows[y] = fieldStorage.advanced(by: y * cols)
        }
    }

    deinit {
        fieldStorage.deinitialize(count: rows * cols)
        fieldStorage.deallocate()
        fieldRows.deallocate()
    }

    func toGameInfo(world: RaceWorld, stats: RaceStats) -> GameInfo_t {
        // clear
        fieldStorage.initialize(repeating: 0, count: rows * cols)

        writeCar(world.player)

        for e in world.enemies {
            writeCar(e)
        }

        var out = GameInfo_t()
        out.score = CInt(stats.score)
        out.high_score = CInt(stats.highScore)
        out.level = CInt(stats.level)
        out.speed = CInt(stats.speed)
        out.pause = stats.pause ? 1 : 0

        // единообразие: next и field одно и то же
        
        out.field = fieldRows
        out.next  = fieldRows

        return out
    }

    private func writeCar(_ car: Car) {
        for cell in car.occupiedCells() {
            guard cell.y >= 0, cell.y < rows, cell.x >= 0, cell.x < cols else { continue }
            fieldStorage[cell.y * cols + cell.x] = 1
        }
    }
}
