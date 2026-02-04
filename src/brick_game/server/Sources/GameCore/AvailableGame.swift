//
//  AvailableGame.swift
//  Server
//
//  Created by Alena Ivanova on 19.01.2026.
//

import Foundation

enum AvailableGame: Int, CaseIterable {
    case tetris = 1
    case snake = 2
    case race = 3

    var name: String {
        switch self {
        case .tetris: return "tetris"
        case .snake: return "snake"
        case .race: return "race"
        }
    }
}
