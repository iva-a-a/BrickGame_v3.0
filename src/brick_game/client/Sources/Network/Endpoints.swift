//
//  Endpoints.swift
//  BrickGame
//
//  Created by Alena Ivanova on 19.01.2026.
//

enum Endpoints {
    case games
    case game(Int)
    case actions
    case state
    
    var method: HTTPMethod {
        switch self {
        case .games, .state: return .get
        case .game(_), .actions: return .post
        }
    }
    
    var path: String {
        switch self {
        case .games: return "/api/games"
        case .game(let id): return "/api/games/\(id)"
        case .actions: return "/api/actions"
        case .state: return "/api/state"
        }
    }
}
