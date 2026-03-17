//
//  HighScoreStorageTests.swift
//  BrickGame
//
//  Created by Alena Ivanova on 17.03.2026.
//

import XCTest
@testable import RaceSwiftLib

final class HighScoreStorageTests: XCTestCase {
    
    private let testFilename = "highScoreRaceTest.txt"
    
    override func setUp() {
        super.setUp()
        clearTestFile()
    }
    
    override func tearDown() {
        clearTestFile()
        super.tearDown()
    }
        
    func testSaveHighScore() {
        let expectedScore = 100
        
        HighScoreStorage.save(highScore: expectedScore)
        let savedScore = HighScoreStorage.get()
        
        XCTAssertEqual(savedScore, expectedScore, "Сохраненный счет должен соответствовать ожидаемому")
    }
    
    func testSaveZeroScore() {
        let expectedScore = 0
        
        HighScoreStorage.save(highScore: expectedScore)
        let savedScore = HighScoreStorage.get()
        
        XCTAssertEqual(savedScore, expectedScore, "Нулевой счет должен корректно сохраняться")
    }
    
    func testSaveNegativeScore() {
        let expectedScore = -50
        
        HighScoreStorage.save(highScore: expectedScore)
        let savedScore = HighScoreStorage.get()
        
        XCTAssertEqual(savedScore, expectedScore, "Отрицательный счет должен корректно сохраняться")
    }
    
    func testSaveMaxIntScore() {
        let expectedScore = Int.max
        
        HighScoreStorage.save(highScore: expectedScore)
        let savedScore = HighScoreStorage.get()
        
        XCTAssertEqual(savedScore, expectedScore, "Максимальное значение Int должно корректно сохраняться")
    }
    
    func testSaveMinIntScore() {
        let expectedScore = Int.min
        
        HighScoreStorage.save(highScore: expectedScore)
        let savedScore = HighScoreStorage.get()
        
        XCTAssertEqual(savedScore, expectedScore, "Минимальное значение Int должно корректно сохраняться")
    }
        
    func testOverwriteHighScore() {
        let firstScore = 100
        let secondScore = 200
        
        HighScoreStorage.save(highScore: firstScore)
        HighScoreStorage.save(highScore: secondScore)
        let savedScore = HighScoreStorage.get()
        
        XCTAssertEqual(savedScore, secondScore, "Новый счет должен перезаписывать старый")
    }
    
    func testOverwriteWithLowerScore() {
        let firstScore = 200
        let secondScore = 50
        
        HighScoreStorage.save(highScore: firstScore)
        HighScoreStorage.save(highScore: secondScore)
        let savedScore = HighScoreStorage.get()
        
        XCTAssertEqual(savedScore, secondScore, "Даже меньший счет должен перезаписывать предыдущий")
    }
    
    func testHighScorePersistenceAcrossGameSessions() {
        let initialHighScore = 10
        
        HighScoreStorage.save(highScore: initialHighScore)
        let restoredHighScore = HighScoreStorage.get()
            
        XCTAssertEqual(restoredHighScore, initialHighScore,
                      "High score должен сохраняться между сессиями")
    }
    
    func testHighScoreUpdatesCorrectly() {
        var currentHighScore = HighScoreStorage.get()
        let newScores = [100, 250, 150, 300, 200]
        
        for score in newScores {
            if score > currentHighScore {
                currentHighScore = score
                HighScoreStorage.save(highScore: currentHighScore)
            }
        }
        let finalHighScore = HighScoreStorage.get()
        
        XCTAssertEqual(finalHighScore, 300,
                      "Должен сохраняться максимальный счет")
    }

    func testSavePerformance() {
        measure {
            for i in 1...100 {
                HighScoreStorage.save(highScore: i)
            }
        }
    }
    
    func testGetPerformance() {
        HighScoreStorage.save(highScore: 1000)
        measure {
            for _ in 1...100 {
                _ = HighScoreStorage.get()
            }
        }
    }

    func testFileLocation() {
        let fileName = "highScoreRace.txt"
        
        let fileURL = getFileURL(fileName: fileName)
        
        XCTAssertTrue(fileURL.path.contains("Documents"), "Файл должен находиться в Documents директории")
        XCTAssertTrue(fileURL.lastPathComponent == fileName, "Имя файла должно соответствовать")
    }
    
    func testSaveVeryLargeNumber() {
        let veryLargeNumber = 999_999_999
        
        HighScoreStorage.save(highScore: veryLargeNumber)
        let savedScore = HighScoreStorage.get()
        
        XCTAssertEqual(savedScore, veryLargeNumber, "Очень большие числа должны корректно сохраняться")
    }

    private func clearTestFile() {
        let fileURL = getFileURL(fileName: testFilename)
        try? FileManager.default.removeItem(at: fileURL)
    }
    
    private func getFileURL(fileName: String) -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory,
                                                 in: .userDomainMask).first!
        return documents.appendingPathComponent(fileName)
    }
}
