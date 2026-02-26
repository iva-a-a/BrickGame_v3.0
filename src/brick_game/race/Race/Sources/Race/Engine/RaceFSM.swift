//
//  RaceFSM.swift
//  Race
//
//  Created by Alena Ivanova on 09.01.2026.
//


struct RaceFSM {
    static func nextState(current: RaceGameState, action: Action) -> RaceGameState {
        switch action {
        case .start:
            return (current == .begin || current == .end) ? .generation : current
        case .pause:
            if current == .running { return .break }
            if current == .break { return .running }
            return current
        case .left:
            return (current == .running) ? .movingLeft : current
        case .right:
            return (current == .running) ? .movingRight : current
        case .terminate:
            return .end
        case .up, .down, .action, .none:
            return current
        }
    }
}
