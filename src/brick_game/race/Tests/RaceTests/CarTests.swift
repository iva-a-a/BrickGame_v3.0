//
//  CarTests.swift
//  BrickGame
//
//  Created by Alena Ivanova on 17.03.2026.
//

import XCTest
@testable import RaceSwiftLib

final class CarTests: XCTestCase {
    
    func testOccupiedCellsWithSimpleBody() {
        let body = [Coordinate(x: 0, y: 0), Coordinate(x: 1, y: 0)]
        let car = Car(upLeftPosition: Coordinate(x: 5, y: 5), body: body)
        
        let cells = car.occupiedCells()
        let expectedCells = [
            Coordinate(x: 5, y: 5),
            Coordinate(x: 6, y: 5)
        ]
        
        XCTAssertEqual(Set(cells), Set(expectedCells),
                      "Занятые ячейки должны быть смещены на позицию машины")
    }
    
    func testOccupiedCellsWithEmptyBody() {
        let car = Car(upLeftPosition: Coordinate(x: 5, y: 5), body: [])
        
        let cells = car.occupiedCells()
        
        XCTAssertTrue(cells.isEmpty, "Пустое тело должно давать пустой список ячеек")
    }
    
    func testCarEquality() {
        let car1 = Car(upLeftPosition: Coordinate(x: 1, y: 1), body: [Coordinate(x: 0, y: 0)])
        let car2 = Car(upLeftPosition: Coordinate(x: 1, y: 1), body: [Coordinate(x: 0, y: 0)])
        let car3 = Car(upLeftPosition: Coordinate(x: 2, y: 1), body: [Coordinate(x: 0, y: 0)])
        
        XCTAssertEqual(car1, car2, "Одинаковые машины должны быть равны")
        XCTAssertNotEqual(car1, car3, "Разные машины не должны быть равны")
    }
}
