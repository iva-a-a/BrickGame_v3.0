//
//  EmptyResponse.swift
//  BrickGame
//
//  Created by Alena Ivanova on 04.02.2026.
//

import Foundation

// Для ответов без тела (POST /games/{id}, POST /actions возвращают .ok)
public struct EmptyResponse: Decodable, Sendable {
    public init() {}
}
