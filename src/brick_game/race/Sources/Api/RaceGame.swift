//
//  RaceGame.swift
//  Race
//
//  Created by Alena Ivanova on 15.01.2026.
//

import Foundation
import TetrisCLib

public final class RaceGame {
    private let engine = RaceController()
    private let converter = RaceInfoConverter()
    
    public init() {}

    public func userInput(action: UserAction_t, hold: Bool) {
        engine.setInput(Action(action), hold: hold)
    }

    public func updateCurrentState() -> GameInfo_t {
        let (world, stats) = engine.update()
        return converter.toGameInfo(world: world, stats: stats)
    }
}
