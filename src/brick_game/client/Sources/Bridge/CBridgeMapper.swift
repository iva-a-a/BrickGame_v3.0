//
//  CBridgeMapper.swift
//  BrickGame
//
//  Created by Alena Ivanova on 10.03.2026.
//


import Foundation
@preconcurrency import BrickGameCAPI
import BrickGameAPI

enum CBridgeMapper {
    static func allocMatrix(rows: Int, cols: Int) -> UnsafeMutablePointer<UnsafeMutablePointer<CInt>?>? {
        let rowPointers = UnsafeMutablePointer<UnsafeMutablePointer<CInt>?>.allocate(capacity: rows)
        rowPointers.initialize(repeating: nil, count: rows)

        for row in 0..<rows {
            let colsPointer = UnsafeMutablePointer<CInt>.allocate(capacity: cols)
            colsPointer.initialize(repeating: 0, count: cols)
            rowPointers[row] = colsPointer
        }

        return rowPointers
    }

    static func copyBoolMatrix(
        _ source: [[Bool]],
        to destination: UnsafeMutablePointer<UnsafeMutablePointer<CInt>?>?,
        rows: Int,
        cols: Int
    ) {
        guard let destination else { return }

        let rowCount = min(source.count, rows)

        for row in 0..<rowCount {
            let sourceRow = source[row]
            let colCount = min(sourceRow.count, cols)

            guard let destinationRow = destination[row] else { continue }

            for col in 0..<colCount {
                destinationRow[col] = sourceRow[col] ? 1 : 0
            }

            if colCount < cols {
                for col in colCount..<cols {
                    destinationRow[col] = 0
                }
            }
        }

        if rowCount < rows {
            for row in rowCount..<rows {
                guard let destinationRow = destination[row] else { continue }
                for col in 0..<cols {
                    destinationRow[col] = 0
                }
            }
        }
    }

    static func apply(_ state: GameState, to info: inout GameInfo_t, nextStorage: UnsafeMutablePointer<UnsafeMutablePointer<CInt>?>?) {
        copyBoolMatrix(
            state.field,
            to: info.field,
            rows: BridgeConstants.rowsBoard,
            cols: BridgeConstants.colsBoard
        )

        if state.next.isEmpty {
            info.next = nil
        } else {
            info.next = nextStorage
            copyBoolMatrix(
                state.next,
                to: nextStorage,
                rows: BridgeConstants.rowsFigure,
                cols: BridgeConstants.colsFigure
            )
        }

        info.score = CInt(state.score)
        info.high_score = CInt(state.highScore)
        info.level = CInt(state.level)
        info.speed = CInt(state.speed)
        info.pause = state.pause ? 1 : 0
    }

    static func makeAvailableGames(_ games: [GameInfo]) -> AvailableGames_t {
        guard !games.isEmpty else {
            return AvailableGames_t(items: nil, count: 0)
        }

        let items = UnsafeMutablePointer<GameListItem_t>.allocate(capacity: games.count)

        for (index, game) in games.enumerated() {
            items[index] = GameListItem_t(
                id: CInt(game.id),
                name: strdup(game.name)
            )
        }

        return AvailableGames_t(items: items, count: CInt(games.count))
    }

    static func freeAvailableGames(_ games: AvailableGames_t) {
        guard let items = games.items else { return }

        for index in 0..<Int(games.count) {
            free(items[index].name)
        }

        items.deallocate()
    }
}
