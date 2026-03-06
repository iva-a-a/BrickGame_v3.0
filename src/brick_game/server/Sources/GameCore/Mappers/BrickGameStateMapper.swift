//
//  BrickGameStateMapper.swift
//  Server
//
//  Created by Alena Ivanova on 28.01.2026.
//

import TetrisCLib
import BrickGameAPI

enum BrickGameStateMapper {
    static let rowsBoard = 20
    static let colsBoard = 10

    static let rowsFigure = 4
    static let colsFigure = 4

    public static func map(info: GameInfo_t) -> GameState {
        let field = matrixToBool(
            info.field,
            rows: rowsBoard,
            cols: colsBoard
        )

        let next = matrixToBoolOrEmpty(
            info.next,
            rows: rowsFigure,
            cols: colsFigure
        )

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

    private static func matrixToBoolOrEmpty(
        _ ptr: UnsafeMutablePointer<UnsafeMutablePointer<CInt>?>?,
        rows: Int,
        cols: Int
    ) -> [[Bool]] {
        guard let ptr else { return [] }
        return matrixToBool(ptr, rows: rows, cols: cols)
    }

    private static func matrixToBool(
        _ ptr: UnsafeMutablePointer<UnsafeMutablePointer<CInt>?>?,
        rows: Int,
        cols: Int
    ) -> [[Bool]] {
        guard let ptr else {
            return Array(
                repeating: Array(repeating: false, count: cols),
                count: rows
            )
        }

        var result = Array(
            repeating: Array(repeating: false, count: cols),
            count: rows
        )

        for r in 0..<rows {
            guard let rowPtr = ptr[r] else { continue }
            for c in 0..<cols {
                result[r][c] = rowPtr[c] != 0
            }
        }

        return result
    }
}
