//
//  HighScoreStorage.swift
//  Race
//
//  Created by Alena Ivanova on 25.02.2026.
//

import Foundation

struct HighScoreStorage {
    static private let filename: String = "highScoreRace.txt"
    
    static func save(highScore: Int) {
        let fileURL = getFileURL(fileName: filename)
        do {
            try String(highScore).write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Failed to save high score: \(error)")
        }
    }
    
    static func get() -> Int {
        let fileURL = getFileURL(fileName: filename)
        do {
            let content = try String(contentsOf: fileURL, encoding: .utf8)
            return Int(content.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
        } catch {
            return 0
        }
    }
    
    static private func getFileURL(fileName: String) -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory,
                                                 in: .userDomainMask).first!
        return documents.appendingPathComponent(fileName)
    }
}

