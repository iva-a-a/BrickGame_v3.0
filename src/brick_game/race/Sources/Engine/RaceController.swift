//
//  RaceController.swift
//  Race
//
//  Created by Alena Ivanova on 12.01.2026.
//

import Foundation
import Dispatch

final class RaceController {
    var world = RaceWorld()
    var stats = RaceStats()
    var state: RaceGameState = .begin

    private var isBoosting = false
    private var baseSpeed: Int = GameConstants.Gameplay.baseSpeedMs

    private var lastMoveTimeMs: UInt64 = 0
    private var lastSpawnTimeMs: UInt64 = 0

    func userInput(_ action: Action, hold: Bool) {
        if action == .up {
            isBoosting = hold
            return
        }

        let oldState = state
        let newState = RaceFSM.nextState(current: state, action: action)
        state = newState
        
        if (oldState == .begin && newState == .running) ||
           (oldState == .end && newState == .running) ||
           (oldState == .exit && newState == .running) {
            clearGame()
            resetTimers()
        }
        if oldState == .break && newState == .running {
            resetTimers()
        }
    }

    func update() -> (RaceWorld, RaceStats) {
        defer {
            isBoosting = false
        }
        switch state {
        case .begin:
            break
        case .break:
            stats.pause = true
        case .end:
            finishGame()
        case .exit:
            break
        case .movingLeft:
            stats.pause = false
            let nextPlayer = RaceGameplay.nextPlayer(for: world, action: .left)
            if RaceGameplay.intersects(player: nextPlayer, enemies: world.enemies) {
                finishGame()
            } else {
                RaceGameplay.movePlayer(world: &world, to: nextPlayer)
                state = .running
            }
        case .movingRight:
            stats.pause = false
            let nextPlayer = RaceGameplay.nextPlayer(for: world, action: .right)
            if RaceGameplay.intersects(player: nextPlayer, enemies: world.enemies) {
                finishGame()
            } else {
                RaceGameplay.movePlayer(world: &world, to: nextPlayer)
                state = .running
            }
        case .running:
            stats.pause = false
            updateRunningWorld()
        }
        return (world, stats)
    }

    private func updateRunningWorld() {
        let now = currentTimeMs()

        refreshSpeed()
        if lastMoveTimeMs == 0 {
            lastMoveTimeMs = now
        }
        if lastSpawnTimeMs == 0 {
            lastSpawnTimeMs = now
        }

        while now - lastMoveTimeMs >= UInt64(stats.speed) {
            let nextEnemies = RaceGameplay.nextEnemies(for: world)
            if RaceGameplay.intersects(player: world.player, enemies: nextEnemies) {
                finishGame()
                return
            }
            RaceGameplay.moveEnemies(world: &world, to: nextEnemies, score: &stats.score)
            lastMoveTimeMs += UInt64(stats.speed)
            refreshSpeed()
        }

        let spawnInterval = UInt64(stats.speed * GameConstants.Gameplay.spawnRate)
        while now - lastSpawnTimeMs >= spawnInterval {
            RaceGameplay.trySpawnEnemy(world: &world)
            lastSpawnTimeMs += spawnInterval
        }
    }

    private func refreshSpeed() {
        RaceGameplay.changeHighScore(score: stats.score, highScore: &stats.highScore)
        RaceGameplay.increaseLevel(score: stats.score, level: &stats.level)
        RaceGameplay.updateSpeed(level: stats.level, speed: &baseSpeed)

        stats.displaySpeed = baseSpeed

        stats.speed = isBoosting
            ? max(
                GameConstants.Gameplay.minSpeedMs,
                baseSpeed / GameConstants.Gameplay.boostMultiplier
            )
            : baseSpeed
    }

    private func clearGame() {
        world.clear()
        stats.clear()
        stats.highScore = HighScoreStorage.get()

        isBoosting = false
        baseSpeed = GameConstants.Gameplay.baseSpeedMs
        stats.speed = baseSpeed
        stats.displaySpeed = baseSpeed

        lastMoveTimeMs = 0
        lastSpawnTimeMs = 0
    }

    private func resetTimers() {
        let now = currentTimeMs()
        lastMoveTimeMs = now
        lastSpawnTimeMs = now
    }

    private func finishGame() {
        state = .end
        RaceGameplay.changeHighScore(score: stats.score, highScore: &stats.highScore)
        HighScoreStorage.save(highScore: stats.highScore)
    }

    private func currentTimeMs() -> UInt64 {
        DispatchTime.now().uptimeNanoseconds / 1_000_000
    }
}
