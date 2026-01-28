//
//  SnakeEngine.swift
//  Server
//
//  Created by Alena Ivanova on 28.01.2026.
//

import GameCore
import SnakeCPPLib

struct SnakeEngine: BrickGameEngine {
    func userInput(actionId: Int, hold: Bool)  {
        snake_userInput(UserAction_t(UInt32(actionId)), hold)
    }
    
    func getState() -> GameCore.GameState {
        let info = snake_updateCurrentState()
        return BrickGameStateMapper.map(info)
    }
}
