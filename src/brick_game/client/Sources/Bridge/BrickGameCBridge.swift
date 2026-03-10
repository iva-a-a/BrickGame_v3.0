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
    var availableGames: [GameInfo] = []
}

final class BridgeState: @unchecked Sendable {
    static let shared = BridgeState()
    private var storageLock = OSAllocatedUnfairLock(initialState: BridgeStorage())

    private init() {
        allocateOnce()
        setupService()
    }

    private func setupService() {
        let server = ProcessInfo.processInfo.environment["GAME_SERVER_URL"] ?? "http://localhost:8080"
        guard let baseURL = URL(string: server) else { return }

        let client = NetworkClient(baseURL: baseURL)
        let api = ApiService(client: client)

        storageLock.withLock { s in
            s.service = api
        }
    }

    private func allocateOnce() {
        storageLock.withLock { s in
            s.info.field = Self.allocMatrix(rows: Int(ROWS_BOARD), cols: Int(COL_BOARD))
            s.nextStorage = Self.allocMatrix(rows: Int(ROWS_FIGURE), cols: Int(COL_FIGURE))
            s.info.next = s.nextStorage
            s.info.score = 0
            s.info.high_score = 0
            s.info.level = 0
            s.info.speed = 0
            s.info.pause = 0
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

    private static func copy(
        _ src: [[Bool]],
        to dst: UnsafeMutablePointer<UnsafeMutablePointer<CInt>?>?,
        rows: Int,
        cols: Int
    ) {
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
        let api = storageLock.withLock { $0.service }
        guard let api else { return }

        Task { [weak self] in
            do {
                try await api.sendAction(actionId: Int(action.rawValue), hold: hold)
                await self?.fetch(force: true)
            } catch {
                print("sendAction error:", error)
            }
        }
    }

    func snapshotSync() -> GameInfo_t {
        let out = storageLock.withLock { s in
            if let st = s.pending {
                Self.copy(st.field, to: s.info.field, rows: Int(ROWS_BOARD), cols: Int(COL_BOARD))

                if st.next.isEmpty {
                    s.info.next = nil
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

        Task { [weak self] in
            await self?.fetch(force: false)
        }

        return out
    }

    func listGamesSync() -> [GameInfo] {
        if let cached = storageLock.withLock({ $0.availableGames.isEmpty ? nil : $0.availableGames }) {
            return cached
        }

        guard let api = storageLock.withLock({ $0.service }) else { return [] }

        let semaphore = DispatchSemaphore(value: 0)
        let resultLock = OSAllocatedUnfairLock(initialState: [GameInfo]())

        Task { [weak self] in
            defer { semaphore.signal() }
            do {
                let list = try await api.listGames()
                resultLock.withLock { $0 = list.games }
                self?.storageLock.withLock { s in
                    s.availableGames = list.games
                }
            } catch {
                print("listGames error:", error)
            }
        }

        semaphore.wait()
        return resultLock.withLock { $0 }
    }

    func makeAvailableGames() -> AvailableGames_t {
        let games = listGamesSync()

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

    func releaseAvailableGames(_ games: AvailableGames_t) {
        guard let items = games.items else { return }

        for i in 0..<Int(games.count) {
            free(items[i].name)
        }
        items.deallocate()
    }

    func selectGameSync(id: Int) -> Bool {
        guard let api = storageLock.withLock({ $0.service }) else { return false }

        let semaphore = DispatchSemaphore(value: 0)
        let okLock = OSAllocatedUnfairLock(initialState: false)

        Task { [weak self] in
            defer { semaphore.signal() }
            do {
                try await api.selectGame(id: id)
                await self?.fetch(force: true)
                okLock.withLock { $0 = true }
            } catch {
                print("selectGame error:", error)
            }
        }

        semaphore.wait()
        return okLock.withLock { $0 }
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

@_cdecl("listAvailableGames")
public func listAvailableGames() -> AvailableGames_t {
    BridgeState.shared.makeAvailableGames()
}

@_cdecl("freeAvailableGames")
public func freeAvailableGames(_ games: AvailableGames_t) {
    BridgeState.shared.releaseAvailableGames(games)
}

@_cdecl("selectGameById")
public func selectGameById(_ id: CInt) -> Bool {
    BridgeState.shared.selectGameSync(id: Int(id))
}
