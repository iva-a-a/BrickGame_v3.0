//
//  BridgeState.swift
//  BrickGame
//
//  Created by Alena Ivanova on 10.03.2026.
//


import Foundation
@preconcurrency import BrickGameCAPI
import BrickGameAPI
import Client
import os.lock

final class BridgeState: @unchecked Sendable {
    static let shared = BridgeState.makeDefault()

    private let api: any ApiServicing
    private let storageLock = OSAllocatedUnfairLock(initialState: BridgeStorage())

    private init(api: any ApiServicing) {
        self.api = api
        allocateOnce()
    }

    static func makeDefault() -> BridgeState {
        let server = ProcessInfo.processInfo.environment["GAME_SERVER_URL"] ?? "http://localhost:8080"
        let baseURL = URL(string: server) ?? URL(string: "http://localhost:8080")!
        let client = NetworkClient(baseURL: baseURL)
        let service = ApiService(client: client)
        return BridgeState(api: service)
    }

    private func allocateOnce() {
        storageLock.withLock { storage in
            storage.info.field = CBridgeMapper.allocMatrix(
                rows: BridgeConstants.rowsBoard,
                cols: BridgeConstants.colsBoard
            )

            storage.nextStorage = CBridgeMapper.allocMatrix(
                rows: BridgeConstants.rowsFigure,
                cols: BridgeConstants.colsFigure
            )

            storage.info.next = storage.nextStorage
            storage.info.score = 0
            storage.info.high_score = 0
            storage.info.level = 0
            storage.info.speed = 0
            storage.info.pause = 0
        }
    }

    func userInputNonBlocking(_ action: UserAction_t, _ hold: Bool) {
        Task { [api, weak self] in
            do {
                try await api.sendAction(actionId: Int(action.rawValue), hold: hold)
                await self?.fetch(force: true)
            } catch {
                print("sendAction error:", error)
            }
        }
    }

    func snapshotSync() -> GameInfo_t {
        let snapshot = storageLock.withLock { storage in
            if let state = storage.pending {
                CBridgeMapper.apply(state, to: &storage.info, nextStorage: storage.nextStorage)
                storage.pending = nil
            }
            return storage.info
        }

        Task { [weak self] in
            await self?.fetch(force: false)
        }

        return snapshot
    }

    func listGamesSync() -> [GameInfo] {
        if let cached = storageLock.withLock({ $0.availableGames.isEmpty ? nil : $0.availableGames }) {
            return cached
        }

        let semaphore = DispatchSemaphore(value: 0)
        let resultLock = OSAllocatedUnfairLock(initialState: [GameInfo]())

        Task { [api, weak self] in
            defer { semaphore.signal() }

            do {
                let list = try await api.listGames()
                resultLock.withLock { $0 = list.games }

                self?.storageLock.withLock { storage in
                    storage.availableGames = list.games
                }
            } catch {
                print("listGames error:", error)
            }
        }

        semaphore.wait()
        return resultLock.withLock { $0 }
    }

    func makeAvailableGames() -> AvailableGames_t {
        CBridgeMapper.makeAvailableGames(listGamesSync())
    }

    func releaseAvailableGames(_ games: AvailableGames_t) {
        CBridgeMapper.freeAvailableGames(games)
    }

    func selectGameSync(id: Int) -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        let resultLock = OSAllocatedUnfairLock(initialState: false)

        Task { [api, weak self] in
            defer { semaphore.signal() }

            do {
                try await api.selectGame(id: id)
                await self?.fetch(force: true)
                resultLock.withLock { $0 = true }
            } catch {
                print("selectGame error:", error)
            }
        }

        semaphore.wait()
        return resultLock.withLock { $0 }
    }

    private func fetch(force: Bool) async {
        let now = Date().timeIntervalSince1970

        let shouldFetch = storageLock.withLock { storage -> Bool in
            if storage.fetchInFlight {
                return false
            }

            if !force, (now - storage.lastFetchAt) < 0.03 {
                return false
            }

            storage.fetchInFlight = true
            storage.lastFetchAt = now
            return true
        }

        guard shouldFetch else { return }

        do {
            let state = try await api.getState()
            storageLock.withLock { storage in
                storage.pending = state
                storage.fetchInFlight = false
            }
        } catch {
            storageLock.withLock { storage in
                storage.fetchInFlight = false
            }
            print("getState error:", error)
        }
    }
}
