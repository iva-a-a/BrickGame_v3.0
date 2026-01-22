//
//  GameInfo.swift
//  Server
//
//  Created by Alena Ivanova on 19.01.2026.
//

import Vapor

struct GameInfo: Content {
    let id: Int
    let name: String
}
