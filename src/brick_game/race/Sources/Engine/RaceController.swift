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
        let oldState = state
        let newState = RaceFSM.nextState(current: state, action: action)
        state = newState

         if (oldState == .begin && newState == .running) ||
            (oldState == .end && newState == .running) {
             clearGame()
         }
    }

    func update() -> (RaceWorld, RaceStats) {

        switch state {
        case .begin:
            clearGame()
        case .break:
            break
        case .end:
            finishGame()
        case .exit:
            break
        case .movingLeft:
            let nextPlayer = RaceGameplay.nextPlayer(for: world, action: .left)
            if RaceGameplay.intersects(player: nextPlayer, enemies: world.enemies) {
                finishGame()
            } else {
                RaceGameplay.movePlayer(world: &world, to: nextPlayer)
                state = .running
            }
        case .movingRight:
            let nextPlayer = RaceGameplay.nextPlayer(for: world, action: .right)
            if RaceGameplay.intersects(player: nextPlayer, enemies: world.enemies) {
                finishGame()
            } else {
                RaceGameplay.movePlayer(world: &world, to: nextPlayer)
                state = .running
            }
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
        
        let nextEnemies = RaceGameplay.nextEnemies(for: world)
        if RaceGameplay.intersects(player: world.player, enemies: nextEnemies) {
            finishGame()
            return
        } else {
            RaceGameplay.moveEnemies(world: &world, to: nextEnemies, score: &stats.score)
        }

        spawnCounter += 1
        if spawnCounter >= GameConstants.Gameplay.spawnRate {
            RaceGameplay.trySpawnEnemy(world: &world)
            spawnCounter = 0
        }
        RaceGameplay.changeHighScore(score: stats.score, highScore: &stats.highScore)
        RaceGameplay.increaseLevel(score: stats.score, level: &stats.level)
        RaceGameplay.updateSpeed(level: stats.level, speed: &stats.speed)
    }

    private func clearGame() {
        world.clear()
        stats.clear()
        stats.highScore = HighScoreStorage.get()
        fallCounter = 0
        spawnCounter = 0
    }
    
    private func finishGame() {
        state = .end
        RaceGameplay.changeHighScore(score: stats.score, highScore: &stats.highScore)
        HighScoreStorage.save(highScore: stats.highScore)
    }
}
