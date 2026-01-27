//
//  ErrorMessage.swift
//  Server
//
//  Created by Alena Ivanova on 19.01.2026.
//

import Vapor

public struct ErrorMessage: Content {
    public let message: String
    
    public init(message: String) {
        self.message = message
    }
}
