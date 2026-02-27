//
//  BrickGameStateMapper.swift
//  Server
//
//  Created by Alena Ivanova on 28.01.2026.
//

import TetrisCLib
import BrickGameAPI

// Но у тетриса info.next часто матрица фигуры 4x4, а не 20x10.


enum BrickGameStateMapper {
    static let rowsBoard = 20
    static let colsBoard = 10

    public static func map(info: GameInfo_t) -> GameState {
        let field = matrixToBool(info.field)
        let next = matrixToBoolOrEmpty(info.next)

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
        _ ptr: UnsafeMutablePointer<UnsafeMutablePointer<CInt>?>?
    ) -> [[Bool]] {
        guard let ptr else { return [] }
        return matrixToBool(ptr)
    }

    private static func matrixToBool(
        _ ptr: UnsafeMutablePointer<UnsafeMutablePointer<CInt>?>?
    ) -> [[Bool]] {

        guard let ptr else {
            return Array(
                repeating: Array(repeating: false, count: colsBoard),
                count: rowsBoard
            )
        }
        var result = Array(
            repeating: Array(repeating: false, count: colsBoard),
            count: rowsBoard
        )
        for r in 0..<rowsBoard {
            guard let rowPtr = ptr[r] else { continue }
            for c in 0..<colsBoard {
                result[r][c] = rowPtr[c] != 0
            }
        }
        return result
    }
}
