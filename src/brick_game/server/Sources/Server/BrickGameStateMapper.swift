//
//  BrickGameStateMapper.swift
//  Server
//
//  Created by Alena Ivanova on 28.01.2026.
//

import TetrisCLib
import GameCore

enum BrickGameStateMapper {
    static let rowsBoard = 20
    static let colsBoard = 10
    static let rowsFigure = 4
    static let colsFigure = 4

    static func map(_ info: GameInfo_t) -> GameState {
        let field = toBoolMatrix(info.field, rows: rowsBoard, cols: colsBoard)
        let next  = toBoolMatrix(info.next,  rows: rowsFigure, cols: colsFigure)

        return GameState(
            field: field,
            next: next,
            score: Int(info.score),
            highScore: Int(info.high_score),
            level: Int(info.level),
            speed: Int(info.speed),
            pause: info.pause != 0
        )
    }

    private static func toBoolMatrix(_ ptr: UnsafeMutablePointer<UnsafeMutablePointer<Int32>?>?,
                                     rows: Int,
                                     cols: Int) -> [[Bool]] {
        guard let ptr else { return Array(repeating: Array(repeating: false, count: cols), count: rows) }
        var matrix = Array(repeating: Array(repeating: false, count: cols), count: rows)
        for r in 0..<rows {
            guard let rowPtr = ptr[r] else { continue }
            for c in 0..<cols {
                matrix[r][c] = rowPtr[c] != 0
            }
        }
        return matrix
    }
}
