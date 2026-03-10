//
//  BrickGameCBridge.swift
//  BrickGame
//
//  Created by Alena Ivanova on 05.03.2026.
//

import Foundation
@preconcurrency import BrickGameCAPI

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
