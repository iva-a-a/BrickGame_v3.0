//
//  RaceFSM.swift
//  Race
//
//  Created by Alena Ivanova on 09.01.2026.
//

import Foundation

struct RaceFSM {
    static func nextState(current: RaceGameState, action: Action) -> RaceGameState {
        switch current {
        case .begin:
            switch action {
            case .start: return .running
            default: return current
            }
        case .running:
            switch action {
            case .pause: return .break
            case .terminate: return .end
            case .left: return .movingLeft
            case .right: return .movingRight
            default: return current
            }
        case .movingLeft, .movingRight: return current
        case .break:
            switch action {
            case .pause: return .running
            case .terminate: return .end
            default: return current
            }
        case .end:
            switch action {
            case .start: return .running
            case .terminate: return .exit
            default: return .end
            }
        case .exit: return .exit
        }
    }
}
