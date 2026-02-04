//
//  SnakeEngine.swift
//  Server
//
//  Created by Alena Ivanova on 28.01.2026.
//

import SnakeCPPLib
import BrickGameAPI

struct SnakeEngine: BrickGameEngine {
    func userInput(actionId: Int, hold: Bool)  {
        snake_userInput(UserAction_t(UInt32(actionId)), hold)
    }
    
    func getState() -> GameState {
        let info = snake_updateCurrentState()
        return BrickGameStateMapper.mapSnake(info)
    }
}
