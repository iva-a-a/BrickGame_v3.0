//
//  RaceFSM.swift
//  Race
//
//  Created by Alena Ivanova on 09.01.2026.
//

struct RaceFSM {
  var state: RaceGameState = .begin

  mutating func handle(action: Action, hold: Bool) {
    switch state {
    case .begin:
      if action == .start { state = .generation }
      if action == .terminate { state = .exit }

    case .generation:
      if action == .terminate { state = .exit }

    case .running:
      switch action {
      case .pause:
        state = .break
      case .left where !hold:
        state = .movingLeft
      case .right where !hold:
        state = .movingRight
      case .terminate:
        state = .end
      default:
        break
      }
    case .movingLeft, .movingRight:
      if action == .terminate { state = .end }

    case .break:
      if action == .pause { state = .running }
      if action == .terminate { state = .end }

    case .end:
      if action == .start { state = .begin }
      if action == .terminate { state = .exit }

    case .exit:
      break
    }
  }

  mutating func handleCollision() {
    if state == .running { state = .end }
  }
}

