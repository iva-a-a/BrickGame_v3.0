//
//  EngineFactory.swift
//  Server
//
//  Created by Alena Ivanova on 20.01.2026.
//

import Foundation

public enum EngineFactory {
    public static func make(_ game: AvailableGame) -> any BrickGameEngine {
        switch game {
        case .tetris:
            return TetrisEngine()
        case .snake:
            return SnakeEngine()
        case .race:
            return MockRaceEngine()
        }
    }
}
