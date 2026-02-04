//
//  Endpoints.swift
//  Server
//
//  Created by Alena Ivanova on 19.01.2026.
//

enum Endpoints {
    case games
    case game(Int)
    case actions
    case state
    
    var method: String {
        switch self {
        case .games, .state: return "GET"
        case .game(_), .actions: return "POST"
        }
    }
    
    var path: String {
        switch self {
        case .games: return "/games"
        case .game(let id): return "/games/\(id)"
        case .actions: return "/actions"
        case .state: return "/state"
        }
    }
}

// продумать reset/restart endpoint
