//
//  CarShapes.swift
//  Race
//
//  Created by Alena Ivanova on 25.02.2026.
//


enum CarShapes {
    // *#* / ### / *#* / ###
    static let player: [Coordinate] = [
        .init(x: 1, y: 0),
        .init(x: 0, y: 1), .init(x: 1, y: 1), .init(x: 2, y: 1),
        .init(x: 1, y: 2),
        .init(x: 0, y: 3), .init(x: 1, y: 3), .init(x: 2, y: 3),
    ]

    // ### / *#* / ### / *#*
    static let enemy: [Coordinate] = [
        .init(x: 0, y: 0), .init(x: 1, y: 0), .init(x: 2, y: 0),
        .init(x: 1, y: 1),
        .init(x: 0, y: 2), .init(x: 1, y: 2), .init(x: 2, y: 2),
        .init(x: 1, y: 3),
    ]

    static let size = (w: 3, h: 4)
}
