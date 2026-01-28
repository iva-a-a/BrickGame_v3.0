//
//  TetrisEngine.swift
//  Server
//
//  Created by Alena Ivanova on 28.01.2026.
//

import GameCore
import TetrisCLib

struct TetrisEngine: BrickGameEngine {
    func userInput(actionId: Int, hold: Bool)  {
        tetris_userInput(UserAction_t(UInt32(actionId)), hold)
    }
    
    func getState() -> GameCore.GameState {
        let info = tetris_updateCurrentState()
        return BrickGameStateMapper.map(info)
    }
}
