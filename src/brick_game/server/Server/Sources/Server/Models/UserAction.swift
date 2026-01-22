//
//  UserAction.swift
//  Server
//
//  Created by Alena Ivanova on 19.01.2026.
//

import Vapor

struct UserAction: Content {
    let actionId: Int
    let hold: Bool
    
    enum CodingKeys: String, CodingKey {
        case actionId = "action_id"
        case hold
    }
}
