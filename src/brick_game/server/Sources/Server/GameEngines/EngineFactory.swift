//
//  EngineFactory.swift
//  Server
//
//  Created by Alena Ivanova on 20.01.2026.
//

import GameCore

enum EngineFactory {
    static func make(_ game: AvailableGame) throws -> any BrickGameEngine {
        switch game {
        case .tetris:
            return MockTetrisEngine()
        case .snake:
            return MockSnakeEngine()
        case .race:
            return MockRaceEngine()
        }
    }
}
