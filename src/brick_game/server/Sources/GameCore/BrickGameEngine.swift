//
//  BrickGameEngine.swift
//  Server
//
//  Created by Alena Ivanova on 19.01.2026.
//


public protocol BrickGameEngine {
    func userInput(actionId: Int, hold: Bool)
    func getState() -> GameState
}
