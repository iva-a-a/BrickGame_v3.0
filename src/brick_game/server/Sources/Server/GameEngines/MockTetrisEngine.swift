//
//  MockTetrisEngine.swift
//  Server
//
//  Created by Alena Ivanova on 20.01.2026.
//

import GameCore

struct MockTetrisEngine: BrickGameEngine {
    func userInput(actionId: Int, hold: Bool) {}
    func getState() -> GameState { sampleState() }
}
struct MockSnakeEngine: BrickGameEngine {
    func userInput(actionId: Int, hold: Bool) {}
    func getState() -> GameState { sampleState() }
}
struct MockRaceEngine: BrickGameEngine {
    func userInput(actionId: Int, hold: Bool) {}
    func getState() -> GameState { sampleState() }
}

private func sampleState() -> GameState {
    GameState(
        field: Array(repeating: Array(repeating: false, count: 10), count: 20),
        next: Array(repeating: Array(repeating: false, count: 4), count: 4),
        score: 0,
        highScore: 0,
        level: 1,
        speed: 1,
        pause: false
    )
}
