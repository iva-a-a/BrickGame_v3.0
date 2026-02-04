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

    static func mapTetris(_ info: GameInfo_t) -> GameState {
        let field = matrixFromIntMatrix(info.field, rows: rowsBoard, cols: colsBoard)
        let next = matrixFromTriples(info.next, rows: rowsBoard, cols: colsBoard)

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

    static func mapSnake(_ info: GameInfo_t) -> GameState {
        let apple = matrixFromTriples(info.field, rows: rowsBoard, cols: colsBoard)
        let snake = matrixFromTriples(info.next, rows: rowsBoard, cols: colsBoard)

        return GameState(
            field: apple,
            next: snake,
            score: Int(info.score),
            highScore: Int(info.high_score),
            level: Int(info.level),
            speed: Int(info.speed),
            pause: info.pause != 0
        )
    }

    private static func matrixFromIntMatrix(
        _ ptr: UnsafeMutablePointer<UnsafeMutablePointer<CInt>?>?,
        rows: Int,
        cols: Int
    ) -> [[Bool]] {
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

    private static func matrixFromTriples(
        _ arr: UnsafeMutablePointer<UnsafeMutablePointer<CInt>?>?,
        rows: Int,
        cols: Int
    ) -> [[Bool]] {
        var matrix = Array(repeating: Array(repeating: false, count: cols), count: rows)
        guard let arr else { return matrix }

        var i = 0
        while let triple = arr[i] {
            let x = Int(triple[0])
            let y = Int(triple[1])
            let color = Int(triple[2])
            if x == -1 && y == -1 && color == -1 { break }

            if (0..<rows).contains(x), (0..<cols).contains(y) {
                matrix[x][y] = true
            }
            i += 1
        }
        return matrix
    }
}
