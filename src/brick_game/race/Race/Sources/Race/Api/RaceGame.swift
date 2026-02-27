//
//  RaceGame.swift
//  Race
//
//  Created by Alena Ivanova on 15.01.2026.
//

import Foundation

public final class RaceGame {
    private let engine = RaceController()

    func userInput(_ action: Action, hold: Bool) {
        engine.setInput(action, hold: hold)
    }

    func updateCurrentState() -> GameInfo {
        engine.update()
    }
}
