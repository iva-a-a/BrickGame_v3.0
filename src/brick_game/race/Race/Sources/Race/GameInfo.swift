//
//  GameInfo.swift
//  Race
//
//  Created by Alena Ivanova on 09.01.2026.
//

struct GameInfo {
  var field: [[Bool]] = Array(
    repeating: Array(repeating: false, count: GameConstants.Field.columns),
    count: GameConstants.Field.rows
  )
  var next: [[Bool]] = Array(
    repeating: Array(repeating: false, count: GameConstants.Field.columns),
    count: GameConstants.Field.rows
  )

  var score: Int = 0
  var highScore: Int = 0
  var level: Int = 1
  var speed: Int = 1
  var pause: Bool = false
}
