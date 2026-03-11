//
//  RaceEngine.swift
//  Server
//
//  Created by Alena Ivanova on 20.01.2026.
//

import BrickGameAPI
import RaceSwiftLib

struct RaceEngine: BrickGameEngine {

    func userInput(actionId: Int, hold: Bool) {
        race_userInput(UInt32(actionId), hold)
    }

    func getState() -> GameState {
        let info = race_updateCurrentState()
        return BrickGameStateMapper.map(info: info)
    }
}
