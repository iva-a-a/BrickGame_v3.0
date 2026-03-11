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
    
    func userInputSync(_ action: UserAction_t, _ hold: Bool) {
        let semaphore = DispatchSemaphore(value: 0)

        Task { [api] in
            defer { semaphore.signal() }
            do {
                try await api.sendAction(actionId: Int(action.rawValue), hold: hold)
            } catch {
                print("sendAction error:", error)
            }
        }

        semaphore.wait()
    }
    
    func snapshotSync() -> GameInfo_t {
        let semaphore = DispatchSemaphore(value: 0)

        Task { [api, weak self] in
            defer { semaphore.signal() }

            do {
                let state = try await api.getState()
                self?.storageLock.withLock { storage in
                    CBridgeMapper.apply(state,
                                        to: &storage.info,
                                        nextStorage: storage.nextStorage)
                }
            } catch {
                print("getState error:", error)
            }
        }

        semaphore.wait()

        return storageLock.withLock { $0.info }
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

        Task { [api] in
            defer { semaphore.signal() }

            do {
                try await api.selectGame(id: id)
                resultLock.withLock { $0 = true }
            } catch {
                print("selectGame error:", error)
            }
        }

        semaphore.wait()
        return resultLock.withLock { $0 }
    }
}
