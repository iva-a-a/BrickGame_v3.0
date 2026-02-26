//
//  ErrorMessage.swift
//  BrickGame
//
//  Created by Alena Ivanova on 19.01.2026.
//

import Foundation

public struct ErrorMessage: Codable, Sendable {
    public let message: String
    
    public init(message: String) {
        self.message = message
    }
}
