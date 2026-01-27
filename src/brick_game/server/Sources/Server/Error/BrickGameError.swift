//
//  BrickGameError.swift
//  Server
//
//  Created by Alena Ivanova on 20.01.2026.
//

import Vapor

public enum BrickGameError: Error {
    case gameNotFound(Int)          // 404
    case gameAlreadyRunning         // 409
    case noGameSelected             // 400
    case invalidAction(String)      // 400
    case internalFailure(String)    // 500
}

public extension BrickGameError {
    var status: HTTPResponseStatus {
        switch self {
        case .gameNotFound: return .notFound
        case .gameAlreadyRunning: return .conflict
        case .noGameSelected, .invalidAction: return .badRequest
        case .internalFailure: return .internalServerError
        }
    }

    var message: String {
        switch self {
        case .gameNotFound(let id): return "Game with id=\(id) not found"
        case .gameAlreadyRunning: return "The user has already started another game"
        case .noGameSelected: return "The user did not start the game"
        case .invalidAction(let m): return m
        case .internalFailure(let m): return m
        }
    }
}

