//
//  BridgeStorage.swift
//  BrickGame
//
//  Created by Alena Ivanova on 10.03.2026.
//


import Foundation
@preconcurrency import BrickGameCAPI
import BrickGameAPI

struct BridgeStorage {
    var info: GameInfo_t = GameInfo_t()
    var nextStorage: UnsafeMutablePointer<UnsafeMutablePointer<CInt>?>?
    var availableGames: [GameInfo] = []
}
