//
//  RaceGameState.swift
//  Race
//
//  Created by Alena Ivanova on 11.12.2025.
//

import Playgrounds

enum RaceGameState {
    case begin
    case generation
    case running
    case `break`
    case movingLeft
    case movingRight
    case end
    case exit
}


#Playground {
    var state: RaceGameState = .begin
    switch state {
    case .begin:
        state = .generation
    case .generation:
        state = .running
    case .running:
        state = .movingLeft
    case .movingLeft:
        state = .movingRight
    case .movingRight:
        state = .break
    case .break:
        state = .end
    case .end:
        state = .exit
    case .exit:
        break
    }
}
