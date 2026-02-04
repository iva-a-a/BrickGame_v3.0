//
//  UserAction.swift
//  Server
//
//  Created by Alena Ivanova on 19.01.2026.
//

import Foundation

public struct UserAction: Codable, Sendable {
    public let actionId: Int
    public let hold: Bool

    public init(actionId: Int, hold: Bool) {
        self.actionId = actionId
        self.hold = hold
    }
    
    public enum CodingKeys: String, CodingKey {
        case actionId = "action_id"
        case hold
    }
}

