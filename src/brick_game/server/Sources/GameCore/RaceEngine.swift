//
//  RaceEngine.swift
//  Server
//
//  Created by Alena Ivanova on 20.01.2026.
//

import BrickGameAPI
import RaceSwiftLib
import TetrisCLib

struct RaceEngine: BrickGameEngine {
    private let game = RaceGame()

    func userInput(actionId: Int, hold: Bool) {
        game.userInput(action: UserAction_t(UInt32(actionId)), hold: hold)
    }

    func getState() -> GameState {
        let info = game.updateCurrentState()
        return BrickGameStateMapper.map(info: info)
    }
}
