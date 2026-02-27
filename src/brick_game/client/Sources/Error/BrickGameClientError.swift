//
//  BrickGameClientError.swift
//  BrickGame
//
//  Created by Alena Ivanova on 04.02.2026.
//

import Foundation

public enum BrickGameClientError: Error, LocalizedError, Sendable {
    case invalidURL
    case transport(any Error)
    case decoding(any Error)
    case server(status: Int, message: String)
    case invalidResponse

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid server URL"
        case .transport(let err):
            return "Network error: \(err.localizedDescription)"
        case .decoding(let err):
            return "Decoding error: \(err.localizedDescription)"
        case .server(let status, let message):
            return "Server error (\(status)): \(message)"
        case .invalidResponse:
            return "Invalid HTTP response"
        }
    }
}
