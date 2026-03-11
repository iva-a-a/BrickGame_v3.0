//
//  RaceController.swift
//  Race
//
//  Created by Alena Ivanova on 12.01.2026.
//

import Foundation

final class RaceController {
    var world = RaceWorld()
    var stats = RaceStats()
    var state: RaceGameState = .begin

    private var fallCounter: Int = 0
    private var spawnCounter: Int = 0

    func userInput(_ action: Action, hold: Bool) {
        _ = hold
        state = RaceFSM.nextState(current: state, action: action)
        stats.pause = (state == .break)
    }

    func update() -> (RaceWorld, RaceStats) {

        switch state {
        case .begin:
            clearGame()
        case .break:
            break
        case .end:
            RaceGameplay.changeHighScore(score: stats.score, highScore: &stats.highScore)
            HighScoreStorage.save(highScore: stats.highScore)
        case .exit:
            break
        case .movingLeft:
            RaceGameplay.movePlayer(world: &world, action: .left)
            state = .running
            updateRunningWorld()
        case .movingRight:
            RaceGameplay.movePlayer(world: &world, action: .right)
            state = .running
            updateRunningWorld()
        case .running:
            updateRunningWorld()
        }
        return (world, stats)
    }

    private func updateRunningWorld() {
        let fallPeriodTicks = max(1, stats.speed / 100)
        fallCounter += 1
        if fallCounter < fallPeriodTicks {
            return
        }
        fallCounter = 0
        RaceGameplay.moveEnemies(world: &world, score: &stats.score)

        spawnCounter += 1
        if spawnCounter >= 2 {
            _ = RaceGameplay.trySpawnEnemy(world: &world)
            spawnCounter = 0
        }

        if RaceGameplay.hasCollision(world: world) {
            state = .end
            RaceGameplay.changeHighScore(score: stats.score, highScore: &stats.highScore)
            HighScoreStorage.save(highScore: stats.highScore)
            return
        }

        let oldLevel = stats.level
        RaceGameplay.increaseLevel(score: stats.score, level: &stats.level)
        if stats.level != oldLevel {
            RaceGameplay.updateSpeed(level: stats.level, speed: &stats.speed)
        }
    }

    private func clearGame() {
        world.clear()
        stats.clear()
        stats.highScore = HighScoreStorage.get()
        fallCounter = 0
        spawnCounter = 0
    }
}
