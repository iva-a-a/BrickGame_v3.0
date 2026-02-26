//
//  Car.swift
//  Race
//
//  Created by Alena Ivanova on 12.01.2026.
//

struct Car: Equatable {

    var upLeftPosition: Coordinate
    let body: [Coordinate]
    
    func occupiedCells() -> [Coordinate] {
        body.map { Coordinate(x: upLeftPosition.x + $0.x, y: upLeftPosition.y + $0.y) }
    }
}
