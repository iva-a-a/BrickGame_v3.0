//
//  GameInfo.swift
//  Server
//
//  Created by Alena Ivanova on 19.01.2026.
//

import Foundation

public struct GameInfo: Codable {
    public let id: Int
    public let name: String
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
