//
//  RaceLibraryAdapter.swift
//  Race
//
//  Created by Alena Ivanova on 26.02.2026.
//

import Foundation
import TetrisCLib

enum RaceBridge {
    nonisolated(unsafe) static let controller = RaceController()
}

public func race_userInput(_ action: UInt32, _ hold: Bool) {
    guard let action = Action(rawValue: Int(action)) else { return }
    RaceBridge.controller.userInput(action, hold: hold)
}

public func race_updateCurrentState() -> GameInfo_t {
    let (world, stats) = RaceBridge.controller.update()
    let isGameOver = RaceBridge.controller.state == .end
    return RaceInfoConverter.toGameInfo(world: world, stats: stats, isGameOver: isGameOver)
}
