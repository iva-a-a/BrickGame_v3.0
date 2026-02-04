//
//  TetrisEngine.swift
//  Server
//
//  Created by Alena Ivanova on 28.01.2026.
//

import TetrisCLib
import BrickGameAPI

struct TetrisEngine: BrickGameEngine {
    func userInput(actionId: Int, hold: Bool)  {
        tetris_userInput(UserAction_t(UInt32(actionId)), hold)
    }
    
    func getState() -> BrickGameAPI.GameState {
        let info = tetris_updateCurrentState()
        return BrickGameStateMapper.mapTetris(info)
    }
}
