//
//  AvailableGame.swift
//  Server
//
//  Created by Alena Ivanova on 19.01.2026.
//

import Foundation

public enum AvailableGame: Int, CaseIterable {
    case tetris = 1
    case snake = 2
    case race = 3

    public var name: String {
        switch self {
        case .tetris: return "TETRIS"
        case .snake: return "SNAKE"
        case .race: return "RACE"
        }
    }
}
