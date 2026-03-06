//
//  BrickGameCBridge.swift
//  BrickGame
//
//  Created by Alena Ivanova on 05.03.2026.
//

import Foundation
@preconcurrency import BrickGameCAPI
import Client
import BrickGameAPI
import os.lock

let ROWS_BOARD = 20
let COL_BOARD = 10
let ROWS_FIGURE = 4
let COL_FIGURE = 4

private struct BridgeStorage {
    var service: (any ApiServicing)?

    var info: GameInfo_t = GameInfo_t()
    var nextStorage: UnsafeMutablePointer<UnsafeMutablePointer<CInt>?>?

    var pending: GameState?

    var fetchInFlight: Bool = false
    var lastFetchAt: TimeInterval = 0
}

final class BridgeState: @unchecked Sendable {
    static let shared = BridgeState()

    private var storageLock = OSAllocatedUnfairLock(initialState: BridgeStorage())

    private init() {
        allocateOnce()
        bootstrap()
    }

    private func allocateOnce() {
        storageLock.withLock { s in
            s.info.field = Self.allocMatrix(rows: Int(ROWS_BOARD), cols: Int(COL_BOARD))

            // рендер рисует ROWS_FIGURE - 1
            s.nextStorage = Self.allocMatrix(rows: Int(ROWS_FIGURE), cols: Int(COL_FIGURE))
            s.info.next = s.nextStorage

            s.info.score = 0
            s.info.high_score = 0
            s.info.level = 0
            s.info.speed = 0
            s.info.pause = 0
        }
    }

    private func bootstrap() {
        let server = ProcessInfo.processInfo.environment["GAME_SERVER_URL"] ?? "http://localhost:8080"
        guard let baseURL = URL(string: server) else { return }

        Task { [weak self] in
            guard let self else { return }
            let client = NetworkClient(baseURL: baseURL)
            let api = ApiService(client: client)

            self.storageLock.withLock { s in
                s.service = api
            }

            do {
                let list = try await api.listGames()
                if list.games.count >= 2 {
                    let second = list.games[0]
                    try await api.selectGame(id: second.id)
                    await self.fetch(force: true)
                }
            } catch {
                print(error)
            }
        }
    }

    private static func allocMatrix(rows: Int, cols: Int) -> UnsafeMutablePointer<UnsafeMutablePointer<CInt>?>? {
        let rowPtrs = UnsafeMutablePointer<UnsafeMutablePointer<CInt>?>.allocate(capacity: rows)
        rowPtrs.initialize(repeating: nil, count: rows)

        for r in 0..<rows {
            let row = UnsafeMutablePointer<CInt>.allocate(capacity: cols)
            row.initialize(repeating: 0, count: cols)
            rowPtrs[r] = row
        }
        return rowPtrs
    }

    private static func copy(_ src: [[Bool]],
                             to dst: UnsafeMutablePointer<UnsafeMutablePointer<CInt>?>?,
                             rows: Int,
                             cols: Int) {
        guard let dst else { return }

        let rCount = min(src.count, rows)
        for r in 0..<rCount {
            let row = src[r]
            let cCount = min(row.count, cols)
            guard let dstRow = dst[r] else { continue }

            for c in 0..<cCount {
                dstRow[c] = row[c] ? 1 : 0
            }
            if cCount < cols {
                for c in cCount..<cols { dstRow[c] = 0 }
            }
        }

        if rCount < rows {
            for r in rCount..<rows {
                guard let dstRow = dst[r] else { continue }
                for c in 0..<cols { dstRow[c] = 0 }
            }
        }
    }

    func userInputNonBlocking(_ action: UserAction_t, _ hold: Bool) {
        let api: (any ApiServicing)? = storageLock.withLock { s in
            s.service
        }
        guard let api else { return }

        Task.detached { [weak self] in
            do {
                try await api.sendAction(actionId: Int(action.rawValue), hold: hold)
                await self?.fetch(force: true)
            } catch {
                print(error)
            }
        }
    }

    func snapshotSync() -> GameInfo_t {
        let out: GameInfo_t = storageLock.withLock { s in
            if let st = s.pending {
                Self.copy(st.field, to: s.info.field, rows: Int(ROWS_BOARD), cols: Int(COL_BOARD))

                if st.next.isEmpty {
                    s.info.next = nil  // сигнал gameover
                } else {
                    s.info.next = s.nextStorage
                    Self.copy(st.next, to: s.nextStorage, rows: Int(ROWS_FIGURE), cols: Int(COL_FIGURE))
                }

                s.info.score = CInt(st.score)
                s.info.high_score = CInt(st.highScore)
                s.info.level = CInt(st.level)
                s.info.speed = CInt(st.speed)
                s.info.pause = st.pause ? 1 : 0

                s.pending = nil
            }

            return s.info
        }
        Task.detached { [weak self] in
            await self?.fetch(force: false)
        }

        return out
    }

    private func fetch(force: Bool) async {
        let now = Date().timeIntervalSince1970

        let decision = storageLock.withLock { s -> ((any ApiServicing)?, Bool) in
            guard s.service != nil else { return (nil, false) }

            if s.fetchInFlight { return (s.service, false) }
            if !force, (now - s.lastFetchAt) < 0.03 { return (s.service, false) }

            s.fetchInFlight = true
            s.lastFetchAt = now
            return (s.service, true)
        }

        guard let api = decision.0, decision.1 else { return }

        do {
            let st = try await api.getState()
            storageLock.withLock { s in
                s.pending = st
                s.fetchInFlight = false
            }
        } catch {
            storageLock.withLock { s in
                s.fetchInFlight = false
            }
        }
    }
}

@_cdecl("userInput")
public func userInput(_ action: UserAction_t, _ hold: Bool) {
    BridgeState.shared.userInputNonBlocking(action, hold)
}

@_cdecl("updateCurrentState")
public func updateCurrentState() -> GameInfo_t {
    BridgeState.shared.snapshotSync()
}
